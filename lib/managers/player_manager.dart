import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/models/album_image.dart';
import 'package:music_player/models/player_settings.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:uri_to_file/uri_to_file.dart';
import '../api/client.dart';
import '../models/playlist.dart';
import '../notifiers/repeat_button_notifier.dart';
import '../settings_screen/settings_screen.dart';

class PlayerManager extends BaseAudioHandler with QueueHandler, SeekHandler {
  PlayerManager._() {
    _init();
  }

  static var instance = PlayerManager._();

  //audio player and required audio parts
  late AudioPlayer _audioPlayer;
  final AndroidEqualizer androidEqualizer = AndroidEqualizer();
  final AndroidLoudnessEnhancer androidLoudnessEnhancer =
      AndroidLoudnessEnhancer();
  late ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);

  //color skinning for player
  late PaletteGenerator _paletteGenerator;

  //database
  late Isar isar;

  //playlist and a lock to make sure only one song gets loaded at a time instead
  //of skipping two songs forward or backward
  late Playlist internalPlaylist = Playlist(songs: []);
  late bool completedStateLock = false;

  //notifiers for various processes of the player
  final progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(
      current: Duration.zero, buffered: Duration.zero, total: Duration.zero));
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  final colorNotifier = ValueNotifier<ColorsState>(ColorsState());
  final currentSongNotifier =
      ValueNotifier<CurrentSongState>(CurrentSongState(null, false));
  final playlistNotifier = ValueNotifier<List<AudioModel>>([]);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final hasPreviousSongNotifier = ValueNotifier<bool>(true);
  final hasNextSongNotifier = ValueNotifier<bool>(true);
  final repeatButtonNotifier = RepeatButtonNotifier();
  final imageLoadedNotifier = ValueNotifier<Uint8List?>(null);
  final androidEqualizerNotifier =
      ValueNotifier<AndroidEqualizerParameters?>(null);
  final isEqualizerOnNotifier = ValueNotifier<bool>(false);
  final updatePlayerColorAutomaticallyNotifier = ValueNotifier<bool>(true);
  final isSyncToCloudOnNotifier = ValueNotifier<bool>(false);
  final visualisationTypeNotifier =
      ValueNotifier<VisualisationType>(VisualisationType.vinyl);

  //trying to add AudioHandler reference, but seems like this might be a circular reference... -_-
  // late final _audioHandler;

  void _init() async {
    // PlayerManager.instance = await AudioService.init(
    //   builder: () => JioAudioHandler(),
    //   config: AudioServiceConfig(
    //     androidNotificationChannelId: 'co.whitedragon.jiomusic.audio',
    //     androidNotificationChannelName: 'Jio Music',
    //     androidNotificationOngoing: true,
    //     androidStopForegroundOnPause: true
    //   ),
    // );
    _audioPlayer = AudioPlayer(
        audioPipeline: AudioPipeline(
            androidAudioEffects: [androidLoudnessEnhancer, androidEqualizer]));
    updateColors(null);
    _listenToPlayerStates();
    _listenForChangesInSequenceState();
    _loadPlayerSettings();
    _loadPlaylists();
  }

  Future<void> setThemeImage() async {
    drawThemePicture();
  }

  /// Load player settings from the database. This will help persist player
  /// states (shuffle button, repeat button, playlist, current playing item,
  /// themes, etc) if the user closes the player
  void _loadPlayerSettings() async {
    print("loading settings");
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [PlayerSettingsSchema, AlbumImageSchema],
      directory: dir.path,
    );
    PlayerSettings? settings = await isar.playerSettings.get(0);
    if (settings != null) {
      print("Settings exist, loading values");
      //load current theme
      ThemeManager.instance.currentThemeName = settings.currentTheme;
      ThemeManager.instance.themeNotifier.value =
          ThemeManager.colorThemes[settings.currentTheme] ??
              ThemeManager.colorThemes.values.first;
      await setThemeImage();

      //load shuffle
      onShuffleButtonPressed(toShuffle: settings.isShuffleOn);

      //load repeat
      onRepeatButtonPressed(
          repeatButtonState: RepeatState.values[settings.repeatState]);

      //load playlist
      List<String> playlist = settings.playlist;
      List<AudioModel> songs = await OnAudioQuery().querySongs(
          filter: MediaFilter.forSongs(
              audioSortType: AudioSortType.DATE_ADDED,
              orderType: OrderType.DESC_OR_GREATER));
      List<AudioModel> playlistSongs = playlist
          .map(
              (e) => songs.where((element) => element.id.toString() == e).first)
          .toList();
      if (playlistSongs.isNotEmpty) {
        playSongList(playlistSongs, settings.currentSongIndex, play: false);
      }

      //load isEqualizerOn
      isEqualizerOnNotifier.value = settings.isEqualizerOn;
      //load updatePlayerColorAutomatically
      updatePlayerColorAutomaticallyNotifier.value =
          settings.updatePlayerColorAutomatically;
      //load isSyncToCloudOn
      isSyncToCloudOnNotifier.value = settings.isSyncToCloudOn;
      //load visualisationType
      visualisationTypeNotifier.value = settings.visualisationStyle;
      //load song IDs to remove
      LocalSongManager.instance.songIdsToRemove = settings.songIdsToRemove;
      LocalSongManager.instance.artistIdsToRemove = settings.artistIdsToRemove;
      LocalSongManager.instance.albumIdsToRemove = settings.albumIdsToRemove;
      LocalSongManager.instance.foldersToRemove = settings.foldersToRemove;
      await LocalSongManager.instance.querySongs();
      await LocalSongManager.instance.queryArtists();
      await LocalSongManager.instance.queryAlbums();
      await LocalSongManager.instance.queryPlaylists();
    } else {
      print("settings don't exist, making new one");
      //make new settings objects for use next time
      List<AudioModel> sources = internalPlaylist.songs;
      List<String> ids = sources.map((e) => e.id.toString()).toList();
      ids.removeWhere((element) => element.isEmpty);
      await isar.writeTxn(() async {
        await isar.playerSettings.put(PlayerSettings(
            id: 0,
            isShuffleOn: isShuffleModeEnabledNotifier.value,
            repeatState: repeatButtonNotifier.value.index,
            playlist: ids,
            currentSongIndex: internalPlaylist.getCurrentIndex(),
            currentTheme: ThemeManager.instance.currentThemeName,
            isEqualizerOn: isEqualizerOnNotifier.value,
            updatePlayerColorAutomatically:
                updatePlayerColorAutomaticallyNotifier.value,
            isSyncToCloudOn: isSyncToCloudOnNotifier.value,
            visualisationStyle: visualisationTypeNotifier.value,
            songIdsToRemove: LocalSongManager.instance.songIdsToRemove,
            artistIdsToRemove: LocalSongManager.instance.artistIdsToRemove,
            albumIdsToRemove: LocalSongManager.instance.albumIdsToRemove,
        foldersToRemove: LocalSongManager.instance.foldersToRemove));
      });
    }
    print("Finished loading settings");
  }

  Future<String?> getLocalImageUrl(int? albumId) async {
    if (albumId == null) return null;
    // await isar.writeTxn(() async =>await isar.albumImages.clear());
    AlbumImage? image = await isar.albumImages.get(albumId);

    return image?.imageUrl;
  }

  Future<void> setImageUrl(int albumId, String imageUrl) async {
    await isar.writeTxn(() async => await isar.albumImages
        .put(AlbumImage(albumId: albumId, imageUrl: imageUrl)));
  }

  void savePlayerSettings() async {
    print("saving player settings");
    //prepare playlist object
    List<AudioModel> sources = internalPlaylist.songs;
    List<String> ids = sources.map((e) => e.id.toString()).toList();
    ids.removeWhere((element) => element.isEmpty);

    //initialize settings objects if it doesn't exist
    PlayerSettings settings = PlayerSettings(
        id: 0,
        isShuffleOn: isShuffleModeEnabledNotifier.value,
        repeatState: repeatButtonNotifier.value.index,
        playlist: ids,
        currentSongIndex: internalPlaylist.getCurrentIndex(),
        currentTheme: ThemeManager.instance.currentThemeName,
        isEqualizerOn: isEqualizerOnNotifier.value,
        updatePlayerColorAutomatically:
            updatePlayerColorAutomaticallyNotifier.value,
        isSyncToCloudOn: isSyncToCloudOnNotifier.value,
        visualisationStyle: visualisationTypeNotifier.value,
        songIdsToRemove: LocalSongManager.instance.songIdsToRemove,
        artistIdsToRemove: LocalSongManager.instance.artistIdsToRemove,
        albumIdsToRemove: LocalSongManager.instance.albumIdsToRemove,
    foldersToRemove: LocalSongManager.instance.foldersToRemove);
    await isar.writeTxn(() async => await isar.playerSettings.put(settings));
    print("finished saving settings");
  }

  void _loadPlaylists() async {
    await LocalSongManager.instance.queryPlaylists();
    // favorites = await OnAudioRoom().queryFavorites(limit: 1000);
    if (currentSongNotifier.value.song != null) {
      currentSongNotifier.value = CurrentSongState(
          currentSongNotifier.value.song,
          isSongInFavourites(currentSongNotifier.value.song!.id));
    }
    // playlists = await OnAudioRoom().queryPlaylists();
  }

  void _listenToPlayerStates() {
    _audioPlayer.playbackEventStream.listen((event) {
      final isPlaying = _audioPlayer.playing;
      //###HANDLE NOTIFICATION
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: isPlaying,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: 0,
      ));
      //###END NOTIFICATION
      progressNotifier.value = ProgressBarState(
          current: _audioPlayer.position,
          buffered: _audioPlayer.bufferedPosition,
          total: _audioPlayer.duration ?? Duration.zero);
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      //print("DEBUG: PROCESSING STATE IS ${processingState.name}, PLAYING STATE IS ${playerState.playing}");
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        //unlock the next song state
        completedStateLock = false;
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else if (!completedStateLock) {
        //print("DEBUG: #####PROCESSING STATE IS ${processingState.name}, PLAYING STATE IS ${playerState.playing}");
        completedStateLock = true;
        //state is completed, song finished playing
        //if there is the next song in the playlist, or the playlist is set to repeat all, play the next song
        //if the playlist is set to repeat one, play the song again
        if (internalPlaylist.getLoopMode() == LoopMode.one) {
          //play the same song again
          _audioPlayer.seek(Duration.zero);
        } else if (internalPlaylist.hasNext()) {
          //play the next song in the sequence now
          internalPlaylist.nextSong();
          playSong(internalPlaylist.currentIndex, true);
          // AudioModel? nextSong = internalPlaylist.getCurrentSong();
          // if (nextSong == null) return;
          // MediaItem current = MediaItem(
          //     id: nextSong.id.toString(),
          //     title: nextSong.title,
          //     album: nextSong.album,
          //     artist: nextSong.artist,
          //     duration: Duration(milliseconds: nextSong.duration ?? 0),
          //     extras: {
          //       'songModel': nextSong.getMap,
          //       'index': internalPlaylist.getCurrentIndex()
          //     });
          // _playlist = ConcatenatingAudioSource(
          //   children: [
          //     AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
          //         tag: current)
          //   ],
          //   useLazyPreparation: true,
          // );
          // updateQueue([current]);
          // mediaItem.add(current);
          // _audioPlayer.setAudioSource(_playlist,
          //     preload: false, initialIndex: 0, initialPosition: Duration.zero);
        }
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total);
    });
    _audioPlayer.durationStream.listen((duration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: duration ?? Duration.zero);
    });
  }

  //TODO: this method doesn't get called anymore - there's no sequence
  void _listenForChangesInSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) async {
      debugPrint("@!#*!@)(#*!)@*DEBUG");
      if (sequenceState == null) return;
      //set title
      final currentItem = sequenceState.currentSource;
      final itemMetadata = currentItem?.tag as MediaItem?;

      print("DEBUG: now playing: ${itemMetadata!.title}");
      //TODO: try to not depend on songModel attribute
      if (itemMetadata != null &&
          itemMetadata.extras != null &&
          itemMetadata.extras!.containsKey('songModel')) {
        // updateMediaItem(itemMetadata);
        AudioModel? currentSong = AudioModel(itemMetadata.extras?['songModel']);
        currentSongNotifier.value =
            CurrentSongState(currentSong, isSongInFavourites(currentSong.id));

        //fetch artwork colors
        // print()
        if (updatePlayerColorAutomaticallyNotifier.value) {
          updateColorsFromUrl(await getImageUrl(currentSong));
        }

        if (buttonNotifier.value == ButtonState.loading) {
          //print("adding to last and most played");
          //add to last played and most played - only if song started to play
          await LocalSongManager.instance.addToLastAndMostPlayed();
        }

        //save settings
        savePlayerSettings();
      }

      //set playlist TODO: update with OnAudioQuery
      List<AudioModel> playlist = internalPlaylist.songs;
      playlistNotifier.value = playlist;

      //set shuffle mode
      // isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      //set previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        hasPreviousSongNotifier.value = false;
        hasNextSongNotifier.value = false;
      } else {
        hasPreviousSongNotifier.value = internalPlaylist.hasPrevious();
        hasNextSongNotifier.value = internalPlaylist.hasNext();
      }
    });
  }

  Future<void> updateColors(int? id) async {
    //print("updating colors for ID $id");
    if (id == null) {
      colorNotifier.value = ColorsState(
          darkMutedColor:
              ThemeManager.instance.themeNotifier.value.darkMutedColor,
          lightMutedColor:
              ThemeManager.instance.themeNotifier.value.lightMutedColor,
          darkVibrantColor:
              ThemeManager.instance.themeNotifier.value.darkVibrantColor,
          lightVibrantColor:
              ThemeManager.instance.themeNotifier.value.lightVibrantColor,
          mutedColor: ThemeManager.instance.themeNotifier.value.mutedColor,
          vibrantColor: ThemeManager.instance.themeNotifier.value.vibrantColor,
          dominantColor:
              ThemeManager.instance.themeNotifier.value.dominantColor);
      return;
    }
    ArtworkModel? data = await OnAudioQuery().queryArtwork(
      id,
      ArtworkType.AUDIO,
      filter: MediaFilter.forArtwork(artworkSize: 200),
    );
    if (data != null && data.artwork != null) {
      _paletteGenerator =
          await PaletteGenerator.fromImageProvider(MemoryImage(data.artwork!));
      Color dominant = _paletteGenerator.dominantColor?.color ??
          ThemeManager.instance.themeNotifier.value.dominantColor;
      Color muted = _paletteGenerator.mutedColor?.color ??
          HSLColor.fromColor(dominant).withSaturation(0.1).toColor();
      Color vibrant = _paletteGenerator.vibrantColor?.color ??
          HSLColor.fromColor(dominant).withSaturation(0.5).toColor();
      Color darkMuted =
          _paletteGenerator.darkMutedColor?.color ?? darken(muted);
      Color darkVibrant =
          _paletteGenerator.darkVibrantColor?.color ?? darken(vibrant);
      Color lightMuted =
          _paletteGenerator.lightMutedColor?.color ?? lighten(muted, 50);
      Color lightVibrant =
          _paletteGenerator.lightVibrantColor?.color ?? lighten(muted, 50);
      colorNotifier.value = ColorsState(
          darkMutedColor: darkMuted,
          lightMutedColor: lightMuted,
          darkVibrantColor: darkVibrant,
          lightVibrantColor: lightVibrant,
          mutedColor: muted,
          vibrantColor: vibrant,
          dominantColor: dominant);
      //print("'palette_name': ColorState(\ndominantColor: const Color(${dominant.value}),\nmutedColor: const Color(${muted.value}),\nvibrantColor: const Color(${vibrant.value}),\nlightMutedColor: const Color(${lightMuted.value}),\nlightVibrantColor: const Color(${lightVibrant.value}),\ndarkMutedColor: const Color(${darkMuted.value}),\ndarkVibrantColor: const Color(${darkVibrant.value})\n),");
    } else {
      colorNotifier.value = ColorsState(
          darkMutedColor:
              ThemeManager.instance.themeNotifier.value.darkMutedColor,
          lightMutedColor:
              ThemeManager.instance.themeNotifier.value.lightMutedColor,
          darkVibrantColor:
              ThemeManager.instance.themeNotifier.value.darkVibrantColor,
          lightVibrantColor:
              ThemeManager.instance.themeNotifier.value.lightVibrantColor,
          mutedColor: ThemeManager.instance.themeNotifier.value.mutedColor,
          vibrantColor: ThemeManager.instance.themeNotifier.value.vibrantColor,
          dominantColor:
              ThemeManager.instance.themeNotifier.value.dominantColor);
      return;
    }
  }

  Future<void> updateColorsFromUrl(String? url) async {
    print("updating colors for $url");
    if (url == null) {
      colorNotifier.value = ColorsState(
          darkMutedColor:
          ThemeManager.instance.themeNotifier.value.darkMutedColor,
          lightMutedColor:
          ThemeManager.instance.themeNotifier.value.lightMutedColor,
          darkVibrantColor:
          ThemeManager.instance.themeNotifier.value.darkVibrantColor,
          lightVibrantColor:
          ThemeManager.instance.themeNotifier.value.lightVibrantColor,
          mutedColor: ThemeManager.instance.themeNotifier.value.mutedColor,
          vibrantColor: ThemeManager.instance.themeNotifier.value.vibrantColor,
          dominantColor:
          ThemeManager.instance.themeNotifier.value.dominantColor);
      return;
    }
    // ArtworkModel? data = await OnAudioQuery().queryArtwork(
    //   id,
    //   ArtworkType.AUDIO,
    //   filter: MediaFilter.forArtwork(artworkSize: 200),
    // );
    // if (data != null && data.artwork != null) {
      _paletteGenerator =
      await PaletteGenerator.fromImageProvider(NetworkImage(url));
    print(_paletteGenerator);
      Color dominant = _paletteGenerator.dominantColor?.color ??
          ThemeManager.instance.themeNotifier.value.dominantColor;
      Color muted = _paletteGenerator.mutedColor?.color ??
          HSLColor.fromColor(dominant).withSaturation(0.1).toColor();
      Color vibrant = _paletteGenerator.vibrantColor?.color ??
          HSLColor.fromColor(dominant).withSaturation(0.5).toColor();
      Color darkMuted =
          _paletteGenerator.darkMutedColor?.color ?? darken(muted);
      Color darkVibrant =
          _paletteGenerator.darkVibrantColor?.color ?? darken(vibrant);
      Color lightMuted =
          _paletteGenerator.lightMutedColor?.color ?? lighten(muted, 50);
      Color lightVibrant =
          _paletteGenerator.lightVibrantColor?.color ?? lighten(muted, 50);
      colorNotifier.value = ColorsState(
          darkMutedColor: darkMuted,
          lightMutedColor: lightMuted,
          darkVibrantColor: darkVibrant,
          lightVibrantColor: lightVibrant,
          mutedColor: muted,
          vibrantColor: vibrant,
          dominantColor: dominant);
      //print("'palette_name': ColorState(\ndominantColor: const Color(${dominant.value}),\nmutedColor: const Color(${muted.value}),\nvibrantColor: const Color(${vibrant.value}),\nlightMutedColor: const Color(${lightMuted.value}),\nlightVibrantColor: const Color(${lightVibrant.value}),\ndarkMutedColor: const Color(${darkMuted.value}),\ndarkVibrantColor: const Color(${darkVibrant.value})\n),");
    // } else {
    //   colorNotifier.value = ColorsState(
    //       darkMutedColor:
    //       ThemeManager.instance.themeNotifier.value.darkMutedColor,
    //       lightMutedColor:
    //       ThemeManager.instance.themeNotifier.value.lightMutedColor,
    //       darkVibrantColor:
    //       ThemeManager.instance.themeNotifier.value.darkVibrantColor,
    //       lightVibrantColor:
    //       ThemeManager.instance.themeNotifier.value.lightVibrantColor,
    //       mutedColor: ThemeManager.instance.themeNotifier.value.mutedColor,
    //       vibrantColor: ThemeManager.instance.themeNotifier.value.vibrantColor,
    //       dominantColor:
    //       ThemeManager.instance.themeNotifier.value.dominantColor);
    //   return;
    // }
  }

  Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  @override
  Future<void> play() async {
    //print("play sent");
    _audioPlayer.play();
  }

  @override
  Future<void> stop() async {
    //print("stop sent");
  }

  @override
  Future<void> pause() async {
    //print("pause sent");
    _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    //print("seek to ${position.inSeconds} seconds sent");
    _audioPlayer.seek(position);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    //print("skip to item $index sent");
  }

  @override
  Future<void> skipToNext() async {
    onNextSongButtonPressed();
  }

  @override
  Future<void> skipToPrevious() async {
    onPreviousSongButtonPressed();
  }

  void onPreviousSongButtonPressed() async {
    //TODO: change to use internalPlaylist
    if (internalPlaylist.getLoopMode() == LoopMode.one) {
      //play the same song again
      _audioPlayer.seek(Duration.zero);
      return;
    }
    internalPlaylist.previousSong();
    playSong(internalPlaylist.currentIndex, true);
    // AudioModel? nextSong = internalPlaylist.getCurrentSong();
    // if (nextSong == null) return;
    // MediaItem mediaItem = MediaItem(
    //     id: nextSong.id.toString(),
    //     title: nextSong.title,
    //     album: nextSong.album,
    //     artist: nextSong.artist,
    //     duration: Duration(milliseconds: nextSong.duration ?? 0),
    //     extras: {
    //       'songModel': nextSong.getMap,
    //       'index': internalPlaylist.getCurrentIndex()
    //     });
    // _playlist = ConcatenatingAudioSource(
    //   children: [
    //     AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
    //         tag: mediaItem)
    //   ],
    //   useLazyPreparation: true,
    // );
    // updateQueue([mediaItem]);
    // try {
    //   await _audioPlayer.setAudioSource(_playlist,
    //       preload: false, initialIndex: 0, initialPosition: Duration.zero);
    //   _audioPlayer.play();
    // } catch (e) {
    //   if (e is PlayerException) {
    //     //TODO: add what to do if song doesn't exist
    //     onPreviousSongButtonPressed();
    //     // AudioModel errorAudio = songList[index];
    //     // await OnAudioQuery().scanMedia(errorAudio.data);
    //   }
    // }
  }

  void onNextSongButtonPressed() async {
    //TODO: change to use internalPlaylist
    if (internalPlaylist.getLoopMode() == LoopMode.one) {
      //play the same song again
      _audioPlayer.seek(Duration.zero);
      return;
    }
    internalPlaylist.nextSong();
    playSong(internalPlaylist.currentIndex, true);
    // AudioModel? nextSong = internalPlaylist.getCurrentSong();
    // if (nextSong == null) return;
    // MediaItem mediaItem = MediaItem(
    //     id: nextSong.id.toString(),
    //     title: nextSong.title,
    //     album: nextSong.album,
    //     artist: nextSong.artist,
    //     duration: Duration(milliseconds: nextSong.duration ?? 0),
    //     extras: {
    //       'songModel': nextSong.getMap,
    //       'index': internalPlaylist.getCurrentIndex()
    //     });
    // _playlist = ConcatenatingAudioSource(
    //   children: [
    //     AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
    //         tag: mediaItem)
    //   ],
    //   useLazyPreparation: true,
    // );
    // updateQueue([mediaItem]);
    // try {
    //   await _audioPlayer.setAudioSource(_playlist,
    //       preload: false, initialIndex: 0, initialPosition: Duration.zero);
    //   _audioPlayer.play();
    // } catch (e) {
    //   if (e is PlayerException) {
    //     //TODO: add what to do if song doesn't exist
    //     onNextSongButtonPressed();
    //     // AudioModel errorAudio = songList[index];
    //     // await OnAudioQuery().scanMedia(errorAudio.data);
    //   }
    // }
  }

  void onRepeatButtonPressed({RepeatState? repeatButtonState}) {
    if (repeatButtonState != null) {
      repeatButtonNotifier.value = repeatButtonState;
    } else {
      repeatButtonNotifier.nextState();
    }
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        internalPlaylist.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        internalPlaylist.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        internalPlaylist.setLoopMode(LoopMode.all);
        break;
    }
    if (internalPlaylist.songs.isEmpty) {
      hasPreviousSongNotifier.value = false;
      hasNextSongNotifier.value = false;
    } else {
      hasPreviousSongNotifier.value = internalPlaylist.hasPrevious();
      hasNextSongNotifier.value = internalPlaylist.hasNext();
    }

    //save settings
    savePlayerSettings();
  }

  void onShuffleButtonPressed({bool? toShuffle}) async {
    bool isShuffle = toShuffle ?? !isShuffleModeEnabledNotifier.value;
    //print("shuffle is $isShuffle");
    if (isShuffle && _playlist.length > 0 && _playlist.children.isNotEmpty) {
      //try shuffling items in internalPlaylist
      internalPlaylist.shuffle();
    } else if (_playlist.length > 0 && _playlist.children.isNotEmpty) {
      //try unshuffling items in internalPlaylist
      internalPlaylist.unShuffle();
    }
    isShuffleModeEnabledNotifier.value = isShuffle;
    internalPlaylist.setShuffleMode(isShuffle);
    //save settings
    savePlayerSettings();
  }

  void playSongList(List<AudioModel> songList, int index,
      {bool play = true, bool needsReloadOfSongs = false}) async {
    List<AudioModel> playlist = songList.toList();
    //TODO: this call takes too much time - needs to be remade better
    //the only time this is necessary is in the favourites/most played/last played
    //I updated it to be optional
    // if (needsReloadOfSongs) {
    //   var page = 0;
    //   while (page < playlist.length){
    //
    //   }
    //   for (var i = 0; i < playlist.length - 1; i = i + 50) {
    //     AudioModel result = (await OnAudioQuery().querySongs(
    //             filter: MediaFilter.forSongs(toQuery: {
    //       MediaColumns.Audio.ID: [playlist[i].id.toString()]
    //     })))
    //         .first;
    //     playlist[i] = result;
    //   }
    // }
    internalPlaylist.setNewSongs(songs: playlist, currentIndex: index);
    if (playlist.isEmpty) {
      return;
    }
    if (isShuffleModeEnabledNotifier.value) {
      internalPlaylist.shuffle();
    }
    //print("playing ${playlist.length} songs");
    //new solution, using the first element of the playlist to play
    AudioModel? e = internalPlaylist.getCurrentSong();
    if (e == null) return;
    playSong(songList.indexOf(e), play);
  }

  void playSong(int index, bool play) async {
    print("DEBUG: playSong called");
    AudioModel? e = internalPlaylist.getCurrentSong();
    if (e == null) return;
    //get song with content:// URI to play
    //TODO: weird error, sometimes breaks down here, don't know why...
    if (e.uri == null) {
      e = (await OnAudioQuery().querySongs(
              filter: MediaFilter.forAudios(toQuery: {
        MediaColumns.Audio.ID: [e.id.toString()]
      })))
          .first;
    } else {
      if (e.uri!.contains("qq.com")) {
        e = e.copyWith(
            uri: await MusicApiClient.qq.bootstrapTrack(e.getMap['track_id']));
      }
    }

    //TODO: get artwork takes a very long time sometimes, when is it best to do the call?
    // getImageUrl(e).then((value) => print("got image url: $value"));
    String imgUrl = await getImageUrl(e);
    Uri? artUri = Uri.tryParse(imgUrl);

    //update player colors
    print("DEBUG: update colors is ${updatePlayerColorAutomaticallyNotifier.value}");
    if (updatePlayerColorAutomaticallyNotifier.value) {
      print("DEBUG: updating colors");
      updateColorsFromUrl(imgUrl);
    }

    //set previous and next buttons
    if (internalPlaylist.songs.isEmpty || internalPlaylist.getCurrentSong() == null) {
      hasPreviousSongNotifier.value = false;
      hasNextSongNotifier.value = false;
    } else {
      hasPreviousSongNotifier.value = internalPlaylist.hasPrevious();
      hasNextSongNotifier.value = internalPlaylist.hasNext();
    }




    //add to last and most played
    if (buttonNotifier.value == ButtonState.loading) {
      //print("adding to last and most played");
      //add to last played and most played - only if song started to play
      await LocalSongManager.instance.addToLastAndMostPlayed();
    }

    // ArtworkModel? artwork = await OnAudioQuery().queryArtwork(e.id, ArtworkType.AUDIO, filter: MediaFilter.forArtwork(artworkFormat: ArtworkFormatType.PNG, artworkSize: 400, artworkQuality: 100)) ?? await OnAudioQuery().queryArtwork(e.id, ArtworkType.ALBUM) ?? await OnAudioQuery().queryArtwork(e.id, ArtworkType.ARTIST);
    // final directory = (await getExternalStorageDirectory())!.path;
    // String? path = '$directory/notification_image${ThemeManager.instance.currentThemeName.replaceAll(" ", "")}.png';
    // Uri? artUri = Uri.file(path);
    // if (artwork != null && artwork.artwork != null) {
    //   // File imgFile = File('$directory/song_image.png');
    //   // await imgFile.writeAsBytes(artwork.artwork!);
    //   // path = '$directory/song_image.png';
    //   artUri = Uri.tryParse(
    //       'content://media/external/audio/media/${e.id}/albumart');
    // }

    MediaItem nextItem = MediaItem(
        id: e.id.toString(),
        title: e.title,
        album: e.album,
        artist: e.artist,
        duration: Duration(milliseconds: e.duration ?? 0),
        artUri: artUri,
        artHeaders: {'time': Random().nextInt(2000).toString()},
        extras: {'songModel': e.getMap, 'index': index});
    _playlist = ConcatenatingAudioSource(
      children: [AudioSource.uri(Uri.parse(e.uri ?? ''), tag: nextItem)],
      useLazyPreparation: true,
    );

    //previous solution, using the full playlist to play
    // _playlist = ConcatenatingAudioSource(
    //   children: playlist
    //       .map((e) =>
    //       AudioSource.uri(Uri.parse(e.uri ?? ''),
    //           tag: MediaItem(
    //               id: e.id.toString(),
    //               title: e.title,
    //               album: e.album,
    //               artist: e.artist,
    //               extras: {
    //                 'songModel': e.getMap,
    //                 'index': songList.indexOf(e)
    //               })))
    //       .toList(),
    //   useLazyPreparation: true,);
    // await _audioPlayer.stop();
    updateQueue([nextItem]);
    mediaItem.add(nextItem);
    // AudioServiceBackground.setMediaItem(nextItem);
    try {
      await _audioPlayer.setAudioSource(_playlist,
          initialIndex: 0, initialPosition: Duration.zero);
    } catch (e2) {
      if (e2 is PlayerException) {
        //TODO: add what to do if song doesn't exist
        onNextSongButtonPressed();
        File file = File(e.data);
        try {
          if (file.existsSync()) {
            file.deleteSync();
            OnAudioQuery().scanMedia(file.path); // Scan the media 'path'
          }
        } catch (e) {
          //print('$e');
        }
        // AudioModel errorAudio = songList[index];
        // await OnAudioQuery().scanMedia(errorAudio.data);
      }
    }
    if (play) {
      await _audioPlayer.play();
    }
  }

  Future<String> getImageUrl(AudioModel? song) async {
    if (song == null) throw Error();
    String? imageUrl =
        await PlayerManager.instance.getLocalImageUrl(song.albumId);
    var img_url = '';
    if (imageUrl == null) {
      //this code might do things async
      // MusicApiClient.qq.search("${song.artist} ${song.title}", 1).then((Map result) async {
      //   if (result['result'] != null && (result['result'] as List).isNotEmpty) {
      //     img_url = result['result'][0]['img_url'];
      //     await PlayerManager.instance.setImageUrl(song.albumId!, img_url);
      //   }
      // });
      // return img_url;

      //this code waits until completion
      Map result =
          await MusicApiClient.qq.search("${song.artist} ${song.title}", 1);
      if (result['result'] != null && (result['result'] as List).isNotEmpty) {
        img_url = result['result'][0]['img_url'];
        await PlayerManager.instance.setImageUrl(song.albumId!, img_url);
      }
    } else {
      img_url = imageUrl;
    }
    return img_url;
  }

  bool isSongInFavourites(int? id) {
    return LocalSongManager.instance.playlistListNotifier.value.favorites
        .where((element) =>
            element.id == (id ?? currentSongNotifier.value.song?.id ?? -1))
        .toList()
        .isNotEmpty;
  }

  Future<void> addToFavourites(AudioModel? song) async {
    await LocalSongManager.instance.addToFavourites(song);
  }

  Future<void> removeFromFavourites(int? id) async {
    await LocalSongManager.instance.removeFromFavourites(id);
  }

  void checkIfCurrentSongInFavourites() {
    CurrentSongState oldState = currentSongNotifier.value;
    currentSongNotifier.value =
        CurrentSongState(oldState.song, isSongInFavourites(oldState.song?.id));
  }

  void loadEqualizer() async {
    await androidEqualizer.setEnabled(true);
    AndroidEqualizerParameters params = await androidEqualizer.parameters;
    androidEqualizerNotifier.value = params;
    androidEqualizer.parameters.then((params) {
      androidEqualizerNotifier.value = params;
    });
  }
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }

class ColorsState {
  Color darkMutedColor = Colors.blueGrey;
  Color lightMutedColor = Colors.white;
  Color darkVibrantColor = Colors.blue;
  Color lightVibrantColor = Colors.yellow;
  Color dominantColor = Colors.blueAccent;
  Color mutedColor = Colors.blueGrey;
  Color vibrantColor = Colors.lightBlueAccent;

  ColorsState(
      {this.darkMutedColor = Colors.blueGrey,
      this.lightMutedColor = Colors.white,
      this.darkVibrantColor = Colors.blue,
      this.lightVibrantColor = Colors.yellow,
      this.dominantColor = Colors.blueAccent,
      this.mutedColor = Colors.blueGrey,
      this.vibrantColor = Colors.lightBlueAccent});
}

class MetadataState {
  String artist;
  String album;
  String song;
  String imageUrl;

  MetadataState(
      {this.artist = 'Unknown Artist',
      this.album = 'Unknown Album',
      this.song = 'Unknown Song',
      this.imageUrl = ''});
}

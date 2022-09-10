import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/models/player_settings.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/playlist.dart';
import '../notifiers/repeat_button_notifier.dart';

class PlayerManager {
  PlayerManager._() {
    _init();
  }

  static final instance = PlayerManager._();

  //audio player and required audio parts
  late AudioPlayer _audioPlayer;
  final AndroidEqualizer _androidEqualizer = AndroidEqualizer();
  final AndroidLoudnessEnhancer _androidLoudnessEnhancer =
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
  final currentSongNotifier = ValueNotifier<CurrentSongState>(CurrentSongState(null, false));
  final playlistNotifier = ValueNotifier<List<AudioModel>>([]);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final hasPreviousSongNotifier = ValueNotifier<bool>(true);
  final hasNextSongNotifier = ValueNotifier<bool>(true);
  final repeatButtonNotifier = RepeatButtonNotifier();
  final imageLoadedNotifier = ValueNotifier<Uint8List?>(null);

  //various playlists to be kept in memory
  List<FavoritesEntity> favorites = [];
  List<PlaylistEntity> playlists = [];

  void _init() async {
    _audioPlayer = AudioPlayer(
        audioPipeline: AudioPipeline(androidAudioEffects: [
      _androidLoudnessEnhancer,
      _androidEqualizer
    ]));
    updateColors(null);
    _listenToPlayerStates();
    _listenForChangesInSequenceState();
    _loadPlayerSettings();
    _loadPlaylists();
  }

  /// Load player settings from the database. This will help persist player
  /// states (shuffle button, repeat button, playlist, current playing item,
  /// themes, etc) if the user closes the player
  void _loadPlayerSettings() async {
    print("loading settings");
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      schemas: [PlayerSettingsSchema],
      directory: dir.path,
    );
    PlayerSettings? settings = await isar.playerSettingss.get(0);
    if (settings != null) {
      print("Settings exist, loading values");
      //load current theme
      ThemeManager.instance.currentThemeName = settings.currentTheme;
      ThemeManager.instance.themeNotifier.value =
          ThemeManager.colorThemes[settings.currentTheme] ??
              ThemeManager.colorThemes.values.first;

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
    } else {
      print("settings don't exist, making new one");
      //make new settings objects for use next time
      List<AudioModel> sources = internalPlaylist.songs;
      List<String> ids = sources.map((e) => e.id.toString()).toList();
      ids.removeWhere((element) => element.isEmpty);
      await isar.writeTxn((isar) async => await isar.playerSettingss.put(
          PlayerSettings(
              id: 0,
              isShuffleOn: isShuffleModeEnabledNotifier.value,
              repeatState: repeatButtonNotifier.value.index,
              playlist: ids,
              currentSongIndex: internalPlaylist.getCurrentIndex(),
              currentTheme: ThemeManager.instance.currentThemeName)));
    }
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
        currentTheme: ThemeManager.instance.currentThemeName);
    await isar
        .writeTxn((isar) async => await isar.playerSettingss.put(settings));
    print("finished saving settings");
  }

  void _loadPlaylists() async {
    favorites = await OnAudioRoom().queryFavorites(limit: 1000);
    if (currentSongNotifier.value.song != null){
      currentSongNotifier.value = CurrentSongState(currentSongNotifier.value.song, isSongInFavourites(currentSongNotifier.value.song!.id));
    }
    playlists = await OnAudioRoom().queryPlaylists();
  }

  void _listenToPlayerStates() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      print(
          "DEBUG: PROCESSING STATE IS ${processingState.name}, PLAYING STATE IS ${playerState.playing}");
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
        print(
            "DEBUG: #####PROCESSING STATE IS ${processingState.name}, PLAYING STATE IS ${playerState.playing}");
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
          AudioModel nextSong = internalPlaylist.getCurrentSong();
          _playlist = ConcatenatingAudioSource(
            children: [
              AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
                  tag: MediaItem(
                      id: nextSong.id.toString(),
                      title: nextSong.title,
                      album: nextSong.album,
                      artist: nextSong.artist,
                      extras: {
                        'songModel': nextSong.getMap,
                        'index': internalPlaylist.getCurrentIndex()
                      }))
            ],
            useLazyPreparation: true,
          );
          _audioPlayer.setAudioSource(_playlist,
              preload: false, initialIndex: 0, initialPosition: Duration.zero);
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

  void _listenForChangesInSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) async {
      if (sequenceState == null) return;
      //set title
      final currentItem = sequenceState.currentSource;
      final itemMetadata = currentItem?.tag as MediaItem?;

      print("DEBUG: now playing: ${itemMetadata!.title}");
      //TODO: try to not depend on songModel attribute
      if (itemMetadata != null &&
          itemMetadata.extras != null &&
          itemMetadata.extras!.containsKey('songModel')) {
        AudioModel? currentSong = AudioModel(itemMetadata.extras?['songModel']);
        currentSongNotifier.value = CurrentSongState(currentSong, isSongInFavourites(currentSong.id ?? -1));

        //fetch artwork colors
        updateColors(currentSong.id);

        if (buttonNotifier.value == ButtonState.loading) {
          print("adding to last and most played");
          //add to last played and most played - only if song started to play
          LastPlayedEntity lastPlayedSong = currentSong.getMap
              .toLastPlayedEntity(DateTime.now().millisecondsSinceEpoch);
          MostPlayedEntity mostPlayedSong = currentSong.getMap
              .toMostPlayedEntity(DateTime.now().millisecondsSinceEpoch);
          //check if song exists in mostPlayed
          MostPlayedEntity? songInList =
              await OnAudioRoom().queryFromMostPlayed(mostPlayedSong.key);
          if (songInList != null) {
            mostPlayedSong = songInList;
            mostPlayedSong.playCount++;
          }

          await OnAudioRoom().addTo(RoomType.LAST_PLAYED, lastPlayedSong,
              ignoreDuplicate: true);
          await OnAudioRoom().addTo(RoomType.MOST_PLAYED, mostPlayedSong,
              ignoreDuplicate: true);
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
    print("updating colors for ID $id");
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
      print(
          "'azure_coral': ColorState(\ndominantColor: const Color(${dominant.value}),\nmutedColor: const Color(${muted.value}),\nvibrantColor: const Color(${vibrant.value}),\nlightMutedColor: const Color(${lightMuted.value}),\nlightVibrantColor: const Color(${lightVibrant.value}),\ndarkMutedColor: const Color(${darkMuted.value}),\ndarkVibrantColor: const Color(${darkVibrant.value})\n),");
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

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void onPreviousSongButtonPressed() async {
    //TODO: change to use internalPlaylist
    if (internalPlaylist.getLoopMode() == LoopMode.one) {
      //play the same song again
      _audioPlayer.seek(Duration.zero);
      return;
    }
    internalPlaylist.previousSong();
    AudioModel nextSong = internalPlaylist.getCurrentSong();
    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
            tag: MediaItem(
                id: nextSong.id.toString(),
                title: nextSong.title,
                album: nextSong.album,
                artist: nextSong.artist,
                extras: {
                  'songModel': nextSong.getMap,
                  'index': internalPlaylist.getCurrentIndex()
                }))
      ],
      useLazyPreparation: true,
    );
    try {
      await _audioPlayer.setAudioSource(_playlist,
          preload: false, initialIndex: 0, initialPosition: Duration.zero);
      _audioPlayer.play();
    } catch (e) {
      if (e is PlayerException) {
        //TODO: add what to do if song doesn't exist
        onPreviousSongButtonPressed();
        // AudioModel errorAudio = songList[index];
        // await OnAudioQuery().scanMedia(errorAudio.data);
      }
    }
  }

  void onNextSongButtonPressed() async {
    //TODO: change to use internalPlaylist
    if (internalPlaylist.getLoopMode() == LoopMode.one) {
      //play the same song again
      _audioPlayer.seek(Duration.zero);
      return;
    }
    internalPlaylist.nextSong();
    AudioModel nextSong = internalPlaylist.getCurrentSong();
    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(Uri.parse(nextSong.uri ?? ''),
            tag: MediaItem(
                id: nextSong.id.toString(),
                title: nextSong.title,
                album: nextSong.album,
                artist: nextSong.artist,
                extras: {
                  'songModel': nextSong.getMap,
                  'index': internalPlaylist.getCurrentIndex()
                }))
      ],
      useLazyPreparation: true,
    );
    try {
      await _audioPlayer.setAudioSource(_playlist,
          preload: false, initialIndex: 0, initialPosition: Duration.zero);
      _audioPlayer.play();
    } catch (e) {
      if (e is PlayerException) {
        //TODO: add what to do if song doesn't exist
        onNextSongButtonPressed();
        // AudioModel errorAudio = songList[index];
        // await OnAudioQuery().scanMedia(errorAudio.data);
      }
    }
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
    print("shuffle is $isShuffle");
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
      {bool play = true}) async {
    List<AudioModel> playlist = songList.toList();
    internalPlaylist = Playlist(songs: songList, currentIndex: index);
    if (playlist.isEmpty) {
      return;
    }
    if (isShuffleModeEnabledNotifier.value) {
      internalPlaylist.shuffle();
    }
    print("playing ${playlist.length} songs");
    //new solution, using the first element of the playlist to play
    AudioModel e = internalPlaylist.getCurrentSong();
    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(Uri.parse(e.uri ?? ''),
            tag: MediaItem(
                id: e.id.toString(),
                title: e.title,
                album: e.album,
                artist: e.artist,
                extras: {'songModel': e.getMap, 'index': songList.indexOf(e)}))
      ],
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
    try {
      await _audioPlayer.setAudioSource(_playlist,
          preload: false, initialIndex: 0, initialPosition: Duration.zero);
    } catch (e) {
      if (e is PlayerException) {
        //TODO: add what to do if song doesn't exist
        AudioModel errorAudio = songList[index];
        await OnAudioQuery().scanMedia(errorAudio.data);
      }
    }
    if (play) {
      await _audioPlayer.play();
    }
  }

  bool isSongInFavourites(int? id) {
    return favorites.where((element) => element.id == (id ?? currentSongNotifier.value.song?.id ?? -1)).toList().isNotEmpty;
  }

  void addToFavourites(AudioModel? song){
    if (song != null){
      OnAudioRoom().addTo(RoomType.FAVORITES, song.getMap.toFavoritesEntity());
    }else if(currentSongNotifier.value.song != null){
      OnAudioRoom().addTo(RoomType.FAVORITES, currentSongNotifier.value.song!.getMap.toFavoritesEntity());
    }
    _loadPlaylists();
  }

  void removeFromFavourites(int? id){
    if (id != null){
      OnAudioRoom().deleteFrom(RoomType.FAVORITES, id);
    }else if(currentSongNotifier.value.song != null){
      OnAudioRoom().deleteFrom(RoomType.FAVORITES, currentSongNotifier.value.song!.id);
    }
    _loadPlaylists();
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

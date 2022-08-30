import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

import 'notifiers/repeat_button_notifier.dart';

class PlayerManager {
  PlayerManager._() {
    _init();
  }
  static final instance = PlayerManager._();
  static const url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  late AudioPlayer _audioPlayer;
  late PaletteGenerator _paletteGenerator;
  late ConcatenatingAudioSource _playlist;

  final progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(
      current: Duration.zero, buffered: Duration.zero, total: Duration.zero));
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  final colorNotifier = ValueNotifier<ColorsState>(ColorsState());
  final currentSongNotifier = ValueNotifier<AudioModel?>(null);
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatButtonNotifier = RepeatButtonNotifier();
  final imageLoadedNotifier = ValueNotifier<Uint8List?>(null);



  void _init() async {
    _audioPlayer = AudioPlayer();
    // _setInitialPlaylist();
    _updateColors();
    _listenToPlayerStates();
    _listenForChangesInSequenceState();
  }

  // void _setInitialPlaylist() async {
  //   const prefix = 'https://www.soundhelix.com/examples/mp3';
  //   final song1 = Uri.parse('$prefix/SoundHelix-Song-1.mp3');
  //   final song2 = Uri.parse('$prefix/SoundHelix-Song-2.mp3');
  //   final song3 = Uri.parse('$prefix/SoundHelix-Song-3.mp3');
  //   _playlist = ConcatenatingAudioSource(children: [
  //     AudioSource.uri(song1, tag: const MediaItem(id: '1', title: 'Song 1')),
  //     AudioSource.uri(song2, tag: const MediaItem(id: '2', title: 'Song 2')),
  //     AudioSource.uri(song3, tag: const MediaItem(id: '3', title: 'Song 3')),
  //   ]);
  //   await _audioPlayer.setAudioSource(_playlist);
  // }

  void _listenToPlayerStates() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
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
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      //set title
      final currentItem = sequenceState.currentSource;
      final itemMetadata = currentItem?.tag as MediaItem?;
      if (itemMetadata != null && itemMetadata.extras != null && itemMetadata.extras!.containsKey('songModel')){
        AudioModel? currentSong = AudioModel(itemMetadata.extras?.remove('songModel'));
        currentSongNotifier.value = currentSong;
      }



      //update artwork
      // if (currentSong != null) _updateArtwork(currentSong.id);

      //set playlist TODO: update with OnAudioQuery
      final playlist = sequenceState.effectiveSequence;
      final titles = playlist.map((e) => e.tag as MediaItem).toList();
      playlistNotifier.value = titles;

      //set shuffle mode
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      //set previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem &&
            repeatButtonNotifier.value == RepeatState.off;
        isLastSongNotifier.value = playlist.last == currentItem &&
            repeatButtonNotifier.value == RepeatState.off;
      }
    });
  }

  Future<void> _updateColors() async {
    _paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(
        "https://i.picsum.photos/id/217/200/200.jpg?hmac=LoNAUhfCfURrqYjw6WECEWybn4B8y37k5G2odewlZ_Y"));
    final oldColors = colorNotifier.value;
    colorNotifier.value = ColorsState(
        darkMutedColor:
            _paletteGenerator.darkMutedColor?.color ?? oldColors.darkMutedColor,
        lightMutedColor: _paletteGenerator.lightMutedColor?.color ??
            oldColors.lightMutedColor,
        darkVibrantColor: _paletteGenerator.darkVibrantColor?.color ??
            oldColors.darkVibrantColor,
        lightVibrantColor: _paletteGenerator.lightVibrantColor?.color ??
            oldColors.lightVibrantColor,
        mutedColor: _paletteGenerator.mutedColor?.color ?? oldColors.mutedColor,
        vibrantColor:
            _paletteGenerator.vibrantColor?.color ?? oldColors.vibrantColor,
        dominantColor:
            _paletteGenerator.dominantColor?.color ?? oldColors.dominantColor);
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

  void onPreviousSongButtonPressed() {
    _audioPlayer.seekToPrevious();
    _audioPlayer.play();
  }

  void onNextSongButtonPressed() {
    _audioPlayer.seekToNext();
    _audioPlayer.play();
  }

  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  void onShuffleButtonPressed() async {
    final enable = !_audioPlayer.shuffleModeEnabled;
    if (enable) {
      _audioPlayer.shuffle();
    }
    _audioPlayer.setShuffleModeEnabled(enable);
  }

  void playSongList(List<AudioModel> songList, int index) async {
    _playlist = ConcatenatingAudioSource(
        children: songList
            .map((e) => AudioSource.uri(Uri.parse(e.uri ?? ''),
                tag: MediaItem(
                  id: e.id.toString(),
                  title: e.title,
                  album: e.album,
                  artist: e.artist,
                    extras: {
                    'songModel': e.getMap,
                      'index': songList.indexOf(e)
                }
                )))
            .toList());
    await _audioPlayer.setAudioSource(_playlist);
    await _audioPlayer.seek(Duration.zero, index: index);
    await _audioPlayer.play();
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

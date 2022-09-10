import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Playlist {
  List<AudioModel> songs;
  late List<int> playSequence;
  int currentIndex;
  late LoopMode _loopMode = LoopMode.off;
  bool _isShuffleModeOn = false;

  Playlist({required this.songs, this.currentIndex = 0}){
    playSequence = songs.asMap().keys.toList();
  }

  void shuffle(){
    int currentSongId = playSequence.removeAt(currentIndex);
    playSequence.shuffle();
    playSequence.insert(0, currentSongId);
    currentIndex = 0;
  }

  void unShuffle(){
    int currentSongId = playSequence.removeAt(currentIndex);
    playSequence = songs.asMap().keys.toList();
    currentIndex = playSequence.indexOf(currentSongId);
  }

  void nextSong(){
    currentIndex++;
    if (currentIndex > playSequence.length - 1){
      currentIndex = 0;
    }
  }

  void previousSong() {
    currentIndex--;
    if (currentIndex < 0){
      currentIndex = playSequence.length - 1;
    }
  }

  AudioModel getCurrentSong() {
    return songs[playSequence[currentIndex]];
  }

  int getCurrentIndex() {
    return playSequence.isNotEmpty ? playSequence[currentIndex] : -1;
  }

  bool isFirstItem() {
    return currentIndex == 0;
  }

  bool isLastItem() {
    return currentIndex == playSequence.length - 1;
  }

  void setLoopMode(LoopMode loopMode){
    _loopMode = loopMode;
  }

  LoopMode getLoopMode(){
    return _loopMode;
  }

  void setShuffleMode(bool isShuffleModeOn){
    _isShuffleModeOn = isShuffleModeOn;
  }

  bool hasNext() {
    return !isLastItem() || _loopMode == LoopMode.all || _loopMode == LoopMode.one;
  }

  bool hasPrevious() {
    return !isFirstItem() || _loopMode == LoopMode.all || _loopMode == LoopMode.one;
  }
}
import 'package:on_audio_query/on_audio_query.dart';

class CurrentSongState {
  AudioModel? song;
  bool isInFavourites;

  CurrentSongState(this.song, this.isInFavourites);
}
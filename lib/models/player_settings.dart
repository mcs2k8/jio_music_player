import 'package:isar/isar.dart';
import 'package:music_player/notifiers/repeat_button_notifier.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'player_settings.g.dart';

@Collection()
class PlayerSettings {
  @Id()
  int? id;
  bool isShuffleOn;
  int repeatState;
  List<String> playlist;
  int currentSongIndex;
  String currentTheme;

  PlayerSettings(
      {required this.id,
      required this.isShuffleOn,
      required this.repeatState,
      required this.playlist,
      required this.currentSongIndex,
      required this.currentTheme});
}

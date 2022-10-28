import 'package:isar/isar.dart';
part 'player_settings.g.dart';

@Collection()
class PlayerSettings {
  Id? id;
  bool isShuffleOn;
  int repeatState;
  List<String> playlist;
  int currentSongIndex;
  String currentTheme;
  bool isEqualizerOn;
  bool updatePlayerColorAutomatically;
  bool isSyncToCloudOn;
  @enumerated
  final VisualisationType visualisationStyle;
  List<int> songIdsToRemove;
  List<String> foldersToRemove;
  List<int> artistIdsToRemove;
  List<int> albumIdsToRemove;

  PlayerSettings(
      {required this.id,
      required this.isShuffleOn,
      required this.repeatState,
      required this.playlist,
      required this.currentSongIndex,
      required this.currentTheme,
      required this.isEqualizerOn,
      required this.updatePlayerColorAutomatically,
      required this.isSyncToCloudOn,
      required this.visualisationStyle,
      required this.songIdsToRemove,
      required this.artistIdsToRemove,
      required this.albumIdsToRemove,
      required this.foldersToRemove});
}

enum VisualisationType { vinyl, casette, gameboy, nokia }

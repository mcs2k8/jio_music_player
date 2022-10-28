import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'edit_song_list_screen.dart';

class SongListWidget extends StatefulWidget {
  final int? artistId;
  final int? albumId;

  const SongListWidget({Key? key, this.artistId, this.albumId})
      : super(key: key);

  @override
  State<SongListWidget> createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  late final LocalSongManager _songListManager;
  late final ThemeNotifier _themeNotifier;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _songListManager = LocalSongManager.instance;
    _themeNotifier = ThemeManager.instance.themeNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Stack(alignment: Alignment.bottomRight, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(4.0)),
                  Expanded(child: Text('Sync to Cloud')),
                  Switch(value: false, onChanged: (isEnabled) {}),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<ColorState>(
                      valueListenable: _themeNotifier,
                      builder: (_, colorState, __) {
                        return TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              primary: colorState.lightMutedColor,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.play_circle_rounded),
                                Padding(padding: EdgeInsets.all(2.0)),
                                ValueListenableBuilder<List<AudioModel>>(
                                    valueListenable:
                                        _songListManager.songListNotifier,
                                    builder: (_, list, __) {
                                      return Text('Play all (${list.length})');
                                    })
                              ],
                            ));
                      },
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
                ],
              ),
              Expanded(
                  child: ValueListenableBuilder<List<AudioModel>>(
                      valueListenable: _songListManager.songListNotifier,
                      builder: (_, list, __) {
                        //convert items to format for AZList
                        return Material(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.transparent,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return ValueListenableBuilder<CurrentSongState>(
                                    valueListenable: PlayerManager
                                        .instance.currentSongNotifier,
                                    builder: (_, song, __) {
                                      //TODO: add handling for when list is empty
                                      return ValueListenableBuilder<ColorState>(
                                          valueListenable: _themeNotifier,
                                          builder: (_, colorState, __) {
                                            return ListTile(
                                              tileColor: PlayerManager.instance
                                                          .internalPlaylist
                                                          .getCurrentSong()
                                                          ?.id ==
                                                      list[index].id
                                                  ? colorState.mutedColor
                                                  : Colors.transparent,
                                              onTap: () {
                                                PlayerManager.instance
                                                    .playSongList(list, index);
                                              },
                                              onLongPress: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditSongListScreen(
                                                              songs: list,
                                                              selectedIndexes: {
                                                                index
                                                              },
                                                            )));
                                              },
                                              title: Text(
                                                list[index].title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Row(
                                                children: [
                                                  ValueListenableBuilder<
                                                          ColorState>(
                                                      valueListenable:
                                                          _themeNotifier,
                                                      builder:
                                                          (_, colorState, __) {
                                                        return Icon(
                                                          Icons
                                                              .phone_android_rounded,
                                                          size: 16,
                                                          color: colorState
                                                              .lightMutedColor,
                                                        );
                                                      }),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0)),
                                                  Expanded(
                                                      child: Text(
                                                    '${list[index].artist ?? "Unknown Artist"} - ${list[index].album ?? "Unknown Album"}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ))
                                                ],
                                              ),
                                              trailing: IconButton(
                                                  color: _themeNotifier
                                                      .value.lightMutedColor,
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.more_horiz)),
                                            );
                                          });
                                    });
                              },
                            ));
                      }))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              onPressed: () {
                itemScrollController.jumpTo(
                    index: PlayerManager.instance.internalPlaylist
                        .getCurrentIndex(),
                    alignment: 0.3);
              },
              child: const Icon(Icons.adjust_rounded),
              mini: true,
            ),
          )
        ]));
  }
}

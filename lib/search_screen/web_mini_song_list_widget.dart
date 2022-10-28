import 'package:flutter/material.dart';
import 'package:music_player/api/client.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../browse_screen/list_tiles.dart';


class WebMiniSongListWidget extends StatefulWidget {
  // final String? artist;
  // final String? album;
  final List<Map>? songs;
  // final bool isPlaylist;
  // final int playlistKey;

  WebMiniSongListWidget({Key? key, this.songs, })
      : super(key: key);

  @override
  State<WebMiniSongListWidget> createState() => _WebMiniSongListWidgetState();
}

class _WebMiniSongListWidgetState extends State<WebMiniSongListWidget> {
  late final LocalSongManager _songListManager;
  late final ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _songListManager = LocalSongManager.instance;
    _themeNotifier = ThemeManager.instance.themeNotifier;
  }

  @override
  void dispose() {
    LocalSongManager.instance.miniSongListNotifier.value = SearchResultsState([], [], []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listView = [];
    if (widget.songs != null){
      for (Map i in widget.songs! ){
        int index = widget.songs!.indexOf(i);
        listView.add(ValueListenableBuilder<CurrentSongState>(
            valueListenable: PlayerManager
                .instance.currentSongNotifier,
            builder: (_, currentSongState, __) {
              AudioModel? currentSong =
                  currentSongState.song;
              return WebSongTile(
                  currentSong, widget.songs![index],
                      () {
                    PlayerManager.instance.playSongList(
                        widget.songs!.map((e) => MusicApiClient.qq.toAudioModel(e)).toList(), index,
                        needsReloadOfSongs: true);
                  }, "QQ", Color.fromARGB(255, 253, 198, 29));
            }));
      }
    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Expanded(
                    //     child: TextButton(
                    //         onPressed: () {
                    //           PlayerManager.instance.playSongList(
                    //               widget.songs ?? searchResultsState.songs, 0,
                    //               needsReloadOfSongs: true);
                    //         },
                    //         style: TextButton.styleFrom(
                    //           primary: _themeNotifier.value.lightMutedColor,
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             const Icon(Icons.play_circle_rounded),
                    //             const Padding(padding: EdgeInsets.all(2.0)),
                    //             Text(
                    //                 'Play all (${widget.songs?.length ?? searchResultsState.songs.length})')
                    //           ],
                    //         ))),
                    IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
                  ],
                ),
                Expanded(
                    child: Material(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.transparent,
                            child: ListView(
                              children: listView,
                            ),
                          )
                        )
              ],
            )
    );
  }
}

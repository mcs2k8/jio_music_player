import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/playlist_details_screen.dart';
import 'package:music_player/notifiers/playlists_notifier.dart';
import 'package:music_player/playlist.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../managers/player_manager.dart';

class PlayListWidget extends StatefulWidget {
  const PlayListWidget({Key? key}) : super(key: key);

  @override
  State<PlayListWidget> createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child:
            ValueListenableBuilder<PlaylistState>(
              valueListenable: LocalSongManager.instance.playlistListNotifier,
                builder: (_, playlistState, __){
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextButton(
                      //           onPressed: () {},
                      //           style: TextButton.styleFrom(
                      //             primary: ThemeManager.instance.themeNotifier.value.lightMutedColor,
                      //           ),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.play_circle_rounded),
                      //               Padding(padding: EdgeInsets.all(2.0)),
                      //               Text('${playlistState.playlists.length + 3} playlists')
                      //             ],
                      //           )),
                      //     ),
                      //     IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
                      //   ],
                      // ),
                      ListTile(
                        // tileColor: ,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PlaylistDetailsScreen(playlistName: 'Favorites', songs: playlistState.favorites.map((e) => AudioModel(e.getMap)).toList());
                          }));
                        },
                        title: const Text(
                          'Favorites',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${playlistState.favorites.length} songs',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: IconButton(
                            color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz)),
                      ),
                      ListTile(
                        // tileColor: ,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PlaylistDetailsScreen(playlistName: 'Most-Played', songs: playlistState.mostPlayed.map((e) => AudioModel(e.getMap)).toList());
                          }));
                        },
                        title: const Text(
                          'Most-Played',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${playlistState.mostPlayed.length} songs',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: IconButton(
                            color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz)),
                      ),
                      ListTile(
                        // tileColor: ,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PlaylistDetailsScreen(playlistName: 'Last Played', songs: playlistState.lastPlayed.map((e) => AudioModel(e.getMap)).toList());
                          }));
                        },
                        title: const Text(
                          'Last Played',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${playlistState.lastPlayed.length} songs',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: IconButton(
                            color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz)),
                      ),
                      Expanded(
                          child: ListView.separated(
                            itemCount: playlistState.playlists.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                // tileColor: ,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return PlaylistDetailsScreen(playlistName: playlistState.playlists[index].playlistName, songs: playlistState.playlists[index].playlistSongs.map((e) => AudioModel(e.getMap)).toList());
                                  }));
                                },
                                title: Text(
                                  playlistState.playlists[index].playlistName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${playlistState.playlists[index].playlistSongs.length} songs',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                trailing: IconButton(
                                    color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
                                    onPressed: () {},
                                    icon: const Icon(Icons.keyboard_arrow_right_rounded)),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          ))
                    ]);
                },
            ));
  }

  @override
  void initState() {
    super.initState();
    LocalSongManager.instance.queryPlaylists();
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _newPlaylistName = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: ValueListenableBuilder<PlaylistState>(
          valueListenable: LocalSongManager.instance.playlistListNotifier,
          builder: (_, playlistState, __) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      // tileColor: ,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                backgroundColor: ThemeManager.instance.themeNotifier.value.darkMutedColor,
                                titlePadding: EdgeInsets.all(16),
                                contentPadding: EdgeInsets.all(16),
                                title: Text("Create New Playlist"),
                                children: [
                                  TextField(
                                    cursorColor: ThemeManager.instance
                                        .themeNotifier.value.lightVibrantColor,
                                    decoration: InputDecoration(
                                      focusColor: ThemeManager.instance
                                          .themeNotifier.value.lightMutedColor,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ThemeManager
                                                  .instance
                                                  .themeNotifier
                                                  .value
                                                  .lightVibrantColor)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ThemeManager
                                                  .instance
                                                  .themeNotifier
                                                  .value
                                                  .lightMutedColor)),
                                      hintText: "Playlist Name",
                                    ),
                                    onChanged: (text) {
                                      _newPlaylistName = text;
                                    },
                                  ),
                                  SizedBox(height: 24,),
                                  Row(
                                    children: [
                                      Expanded(child: TextButton(onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text("CANCEL"))),
                                      Expanded(child: TextButton(onPressed: () async {
                                        bool successful = await LocalSongManager.instance.createPlaylist(_newPlaylistName);
                                        if (successful){
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(msg: "Playlist created successfully");
                                        }else{
                                          Fluttertoast.showToast(msg: "Error creating playlist");
                                        }
                                      }, child: Text("OK"))),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      leading: Icon(Icons.add_rounded,
                          color: ThemeManager
                              .instance.themeNotifier.value.lightMutedColor),
                      title: const Text(
                        'New Playlist',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      // tileColor: ,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PlaylistDetailsScreen(
                                  playlist: PlaylistEntity(-1, "Favorites", 0, 0, []),
                                  songs: playlistState.favorites
                                      .map((e) => AudioModel(e.getMap))
                                      .toList());
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
                      trailing: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: ThemeManager
                            .instance.themeNotifier.value.lightMutedColor,
                      ),
                    ),
                    ListTile(
                      // tileColor: ,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PlaylistDetailsScreen(
                                  playlist: PlaylistEntity(-1, "Most Played", 0, 0, []),
                                  songs: playlistState.mostPlayed
                                      .map((e) => AudioModel(e.getMap))
                                      .toList());
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
                      trailing: Icon(
                          color: ThemeManager
                              .instance.themeNotifier.value.lightMutedColor,
                          Icons.keyboard_arrow_right_rounded),
                    ),
                    ListTile(
                      // tileColor: ,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PlaylistDetailsScreen(
                                  playlist: PlaylistEntity(-1, "Last Played", 0, 0, []),
                                  songs: playlistState.lastPlayed
                                      .map((e) => AudioModel(e.getMap))
                                      .toList());
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
                      trailing: Icon(
                          color: ThemeManager
                              .instance.themeNotifier.value.lightMutedColor,
                          Icons.keyboard_arrow_right_rounded),
                    ),
                    ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: playlistState.playlists.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onLongPress: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    backgroundColor: ThemeManager.instance.themeNotifier.value.darkMutedColor,
                                    title: const Text("Delete this playlist?"),
                                    actions: [
                                      TextButton(onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text("CANCEL", textAlign: TextAlign.end, style: TextStyle(color: ThemeManager.instance.themeNotifier.value.lightMutedColor),)),
                                      TextButton(onPressed: () {
                                        Navigator.pop(context);
                                        LocalSongManager.instance.deletePlaylist(playlistState.playlists[index].key);
                                      }, child: Text("OK", textAlign: TextAlign.end, style: TextStyle(color: ThemeManager.instance.themeNotifier.value.lightMutedColor),)),
                                    ],
                                  );
                                });
                              },
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return PlaylistDetailsScreen(
                                          playlist: playlistState.playlists[index],
                                          songs: playlistState
                                              .playlists[index].playlistSongs
                                              .map((e) => AudioModel(e.getMap))
                                              .toList());
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
                              trailing: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: ThemeManager
                                    .instance.themeNotifier.value.lightMutedColor,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        )
                  ]),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    LocalSongManager.instance.queryPlaylists();
  }
}

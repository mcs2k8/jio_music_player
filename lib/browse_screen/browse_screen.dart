import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/playlist_list_widget.dart';
import 'package:music_player/search_screen/local_search_screen.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/settings_screen/settings_screen.dart';
import 'player_stripe.dart';
import 'album_list_widget.dart';
import 'artist_list_widget.dart';
import 'song_list_widget.dart';

class BrowseScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier = ThemeManager.instance.themeNotifier;
  final int chosenTab;

  BrowseScreen({
    this.chosenTab = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: chosenTab,
        length: 4,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('All Songs'),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Songs",
                ),
                Tab(
                  text: "Artists",
                ),
                Tab(
                  text: "Albums",
                ),
                Tab(
                  text: "Playlists",
                ),
              ]),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context3) {
                        return LocalSearchScreen();
                      }));
                    },
                    icon: Icon(Icons.search)),
                PopupMenuButton(
                    onSelected: (value) async {
                      print("selected $value");
                      if (value == 2) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context4) {
                          return const SettingsScreen();
                        }));
                      }
                    },
                    color: ThemeManager
                        .instance.themeNotifier.value.darkVibrantColor,
                    itemBuilder: (context2) {
                      return [
                        PopupMenuItem(
                            onTap: () {
                              LocalSongManager.instance.querySongs();
                            },
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(Icons.refresh_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Refresh",
                                  style: TextStyle(
                                      color: ThemeManager.instance.themeNotifier
                                          .value.lightMutedColor),
                                )
                              ],
                            )),
                        PopupMenuItem(
                            onTap: () {
                              print("opening settings");
                              // Navigator.push(context, MaterialPageRoute(builder: (context4){
                              //   return const SettingsScreen();
                              // }));
                            },
                            value: 2,
                            child: Row(
                              children: [
                                const Icon(Icons.settings),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                      color: ThemeManager.instance.themeNotifier
                                          .value.lightMutedColor),
                                )
                              ],
                            ))
                      ];
                    })
              ],
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              // mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                 Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Flex(direction: Axis.vertical, children: [Expanded(
                    flex: 4,
                    child: TabBarView(children: [
                      SongListWidget(),
                      ArtistListWidget(),
                      AlbumListWidget(),
                      PlayListWidget()
                    ]),
                  )],),
                ),
                PlayerStripe(
                  themeNotifier: themeNotifier,
                )
              ],
            )));
  }
}

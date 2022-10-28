import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/browse_screen.dart';
import 'package:music_player/browse_screen/playlist_details_screen.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/notifiers/playlists_notifier.dart';
import 'package:music_player/search_screen/web_search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../browse_screen/player_stripe.dart';
import '../managers/song_list_manager.dart';
import '../managers/theme_manager.dart';
import '../settings_screen/settings_screen.dart';
import '../api/client.dart';
import '../widgets/album_stripe.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:
      //       ThemeManager.instance.themeNotifier.value.darkMutedColor,
      //   shadowColor: darken(
      //       ThemeManager.instance.themeNotifier.value.darkMutedColor, 20),
      //   title: Text("Jio Music"),
      //   leading: Padding(padding: EdgeInsets.all(8), child: Image.asset("assets/icon2.png"),),
      // ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 8)),
                        Hero(
                          tag: "webSearchBar",
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            // margin: EdgeInsets.symmetric(horizontal: 16),
                            color: lighten(
                                ThemeManager
                                    .instance.themeNotifier.value.darkMutedColor,
                                20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return WebSearchScreen();
                                }));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icon2.png",
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                    ),
                                    Text(
                                      "Search for songs",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return BrowseScreen(
                                        chosenTab: 0,
                                      );
                                    }));
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.phone_android_rounded,
                                    size: 40,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Local Songs")
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return BrowseScreen(
                                        chosenTab: 3,
                                      );
                                    }));
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    size: 40,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Playlists")
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return SettingsScreen();
                                    }));
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 40,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  Text("Settings")
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 24)),
                        AlbumStripe(
                          title: "Recently Played",
                          future: _getRecentlyPlayed(),
                          shouldOverlap: true,
                          onGeneralTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return PlaylistDetailsScreen(
                                      playlist: PlaylistEntity(
                                          -1, "Recently Played", 0, 0, []),
                                      songs: LocalSongManager.instance
                                          .playlistListNotifier.value.lastPlayed
                                          .map((e) => AudioModel(e.getMap))
                                          .toList());
                                }));
                          },
                          onItemTap: (int index) {
                            PlayerManager.instance.playSongList(LocalSongManager
                                .instance
                                .playlistListNotifier.value.lastPlayed
                                .map((e) => AudioModel(e.getMap))
                                .toList(), index);
                          },
                        ),
                        Padding(padding: EdgeInsets.only(top: 4.0)),
                        AlbumStripe(
                          title: "Popular on QQ",
                            future: _getQQSongs(), shouldOverlap: false, onGeneralTap: () {  }, onItemTap: (int item) {  },),
                        Padding(padding: EdgeInsets.only(top: 16)),
                        AlbumStripe(
                          title: "Popular on Kugou",
                            future: _getKugouSongs(), shouldOverlap: false, onGeneralTap: () { print("tapped general"); }, onItemTap: (int item) { print("tapped kugou ${item}"); },),
                        Padding(padding: EdgeInsets.only(top: 82)),
                      ],
                    )),
              ],
            ),
          ),
          PlayerStripe(
            themeNotifier: ThemeManager.instance.themeNotifier,
          )
        ],
      ),
    );
  }

  Future<List> _getQQSongs() async {
    List<Map> albums =
    (await MusicApiClient.qq.showPlaylist(0))['result'] as List<Map>;
    return albums;
  }

  Future<List> _getKugouSongs() async {
    List<Map> albums =
    (await MusicApiClient.kugou.showPlaylist(0))['result'] as List<Map>;
    return albums;
  }

  Future<List> _getRecentlyPlayed() async {
    List songs =
        LocalSongManager.instance.playlistListNotifier.value.lastPlayed;
    if (songs.length > 20) {
      songs.removeRange(19, songs.length - 1);
    }
    List<Map> result = [];
    for (LastPlayedEntity e in songs) {
      // if (e.albumId == null) continue;
      Map song = {'id': e.id, 'cover_img_url': '', 'title': e.title};
      if (e.albumId != null) {
        String? imageUrl = await PlayerManager.instance.getLocalImageUrl(e.albumId);

        if (imageUrl == null) {
          Map result =
          await MusicApiClient.qq.search("${e.artist} ${e.title}", 1);
          if (result['result'] != null &&
              (result['result'] as List).isNotEmpty) {
            song['cover_img_url'] = result['result'][0]['img_url'];
            await PlayerManager.instance
                .setImageUrl(e.albumId!, song['cover_img_url']);
          }
        } else {
          song['cover_img_url'] = imageUrl;
        }
      }
      result.add(song);
    }
    return result;
  }
}

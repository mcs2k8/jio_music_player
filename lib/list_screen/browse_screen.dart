import 'package:flutter/material.dart';
import 'package:music_player/theme.dart';
import 'player_stripe.dart';
import 'album_list_widget.dart';
import 'artist_list_widget.dart';
import 'song_list_widget.dart';

class BrowseScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  BrowseScreen({
    Key? key,
    required this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
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
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 4,
                  child: TabBarView(children: [
                    SongListWidget(
                      themeNotifier: themeNotifier,
                    ),
                    ArtistListWidget(
                      themeNotifier: themeNotifier,
                    ),
                    AlbumListWidget(
                      themeNotifier: themeNotifier,

                    ),
                    const Center(
                      child: Text('Podcasts'),
                    )
                  ]),
                ),
                PlayerStripe(
                  themeNotifier: themeNotifier,
                )
              ],
            )));
  }
}







import 'package:flutter/material.dart';
import 'package:music_player/list_screen/player_stripe.dart';
import 'package:music_player/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final ArtistModel artist;
  final ThemeNotifier themeNotifier;

  const ArtistDetailsScreen({Key? key, required this.artist, required this.themeNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Artist'),
            bottom: const TabBar(tabs: [
              Tab(
                text: "Songs",
              ),
              Tab(
                text: "Albums",
              )
            ])),
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: TabBarView(children: [
              Text("songs"),
              Text("albums"),
            ]),
          ),
          PlayerStripe(
            themeNotifier: themeNotifier,
          )
        ],
      ),
      ),
    );
  }
}

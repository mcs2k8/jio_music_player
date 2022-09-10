
import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/player_stripe.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../managers/theme_manager.dart';
import 'mini_song_list_widget.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final List<AudioModel> songs;
  final String playlistName;

  const PlaylistDetailsScreen({Key? key, required this.playlistName, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: Column(
        children: [
          Expanded(child: MiniSongListWidget(
            themeNotifier: ThemeManager.instance.themeNotifier,
            songs: songs,
          )),
          PlayerStripe(themeNotifier: ThemeManager.instance.themeNotifier,)
        ],
      ),
    );
  }
}

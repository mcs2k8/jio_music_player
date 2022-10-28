import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/mini_song_list_widget.dart';
import 'package:music_player/browse_screen/player_stripe.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumDetailsScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailsScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.album),
      ),
      body: Column(
        children: [
          Expanded(child: MiniSongListWidget(
            album: album.id.toString(),
          )),
          PlayerStripe(themeNotifier: ThemeManager.instance.themeNotifier,)
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/player_manager.dart';

class Playlist extends StatelessWidget {
  final PlayerManager _pageManager;

  Playlist(this._pageManager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageManager.colorNotifier.value.darkMutedColor,
      appBar: AppBar(
        foregroundColor: _pageManager.colorNotifier.value.lightMutedColor,
        title: Text("Playlist",),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ValueListenableBuilder<List<MediaItem>>(
                valueListenable: _pageManager.playlistNotifier,
                builder: (context, playlistTitles, _) {
                  return ListView.builder(
                    itemCount: playlistTitles.length,
                      itemBuilder: (context, index){
                      return ListTile(title: Text(playlistTitles[index].title),);
                  });
                },
              )
          )
        ],
      ),
    );
  }

}
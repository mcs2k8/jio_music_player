import 'package:flutter/material.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../managers/player_manager.dart';

class LocalSearchScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const LocalSearchScreen({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  State<LocalSearchScreen> createState() => _LocalSearchScreenState();
}

class _LocalSearchScreenState extends State<LocalSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(

          decoration: InputDecoration(
            hintText: "Search songs on your phone...",
          ),
          onChanged: (text) {
            LocalSongManager.instance.searchSongsArtistsAlbums(text);
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<List<AudioModel>>(
                  valueListenable: LocalSongManager.instance.miniSongListNotifier,
                  builder: (_, list, __){
                    return TextButton(
                        onPressed: () {
                          PlayerManager.instance.playSongList(list, 0);
                        },
                        style: TextButton.styleFrom(
                          primary: widget.themeNotifier.value.lightMutedColor,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_rounded),
                            const Padding(padding: EdgeInsets.all(2.0)),
                            Text('Play all (${list.length})')
                          ],
                        ));
                  },
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
            ],
          ),
          Expanded(
              child: ValueListenableBuilder<List<AudioModel>>(
                  valueListenable: LocalSongManager.instance.miniSongListNotifier,
                  builder: (_, list, __) {
                    //convert items to format for AZList
                    return Material(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: ListView.separated(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ValueListenableBuilder<CurrentSongState>(valueListenable: PlayerManager.instance.currentSongNotifier, builder: (_, currentSong, __){
                            return ListTile(
                              tileColor: currentSong.song?.uri == list[index].uri ? widget.themeNotifier.value.mutedColor : widget.themeNotifier.value.darkMutedColor,
                              onTap: () {
                                PlayerManager.instance.playSongList(list, index);
                              },
                              title: Text(
                                list[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    Icons.phone_android_rounded,
                                    size: 16,
                                    color: widget.themeNotifier.value.lightMutedColor,
                                  ),
                                  const Padding(padding: EdgeInsets.all(4.0)),
                                  Expanded(
                                      child: Text(
                                        '${list[index].artist ?? "Unknown Artist"} - ${list[index].album ?? "Unknown Album"}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ))
                                ],
                              ),
                              trailing: IconButton(
                                  color: widget.themeNotifier.value.lightMutedColor,
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_horiz)),
                            );
                          });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  @override
  void initState() {
    LocalSongManager.instance.miniSongListNotifier.value = [];
  }
}

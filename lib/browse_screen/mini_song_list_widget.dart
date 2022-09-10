import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniSongListWidget extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final String? artist;
  final String? album;
  final List<AudioModel>? songs;

  const MiniSongListWidget(
      {Key? key,
        required ThemeNotifier this.themeNotifier, this.artist, this.album, this.songs})
      : super(key: key);

  @override
  State<MiniSongListWidget> createState() => _MiniSongListWidgetState();
}

class _MiniSongListWidgetState extends State<MiniSongListWidget> {
  late final LocalSongManager _songListManager;
  late final ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _songListManager = LocalSongManager.instance;
    _themeNotifier = widget.themeNotifier;
    if (widget.artist != null || widget.album != null){
      _songListManager.searchSongs(widget.artist, widget.album);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: widget.songs != null ?
                TextButton(
                    onPressed: () {
                      PlayerManager.instance.playSongList(widget.songs!, 0);
                    },
                    style: TextButton.styleFrom(
                      primary: _themeNotifier.value.lightMutedColor,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.play_circle_rounded),
                        const Padding(padding: EdgeInsets.all(2.0)),
                        Text('Play all (${widget.songs!.length})')
                      ],
                    ))
                    : ValueListenableBuilder<List<AudioModel>>(
                  valueListenable: _songListManager.miniSongListNotifier,
                  builder: (_, list, __){
                    return TextButton(
                        onPressed: () {
                          PlayerManager.instance.playSongList(list, 0);
                        },
                        style: TextButton.styleFrom(
                          primary: _themeNotifier.value.lightMutedColor,
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
              child: widget.songs != null ?
              Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: ListView.separated(
                  itemCount: widget.songs!.length,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder<CurrentSongState>(valueListenable: PlayerManager.instance.currentSongNotifier, builder: (_, currentSongState, __){
                      AudioModel? currentSong = currentSongState.song;
                      return ListTile(
                        tileColor: currentSong?.uri == widget.songs![index].uri ? _themeNotifier.value.mutedColor : _themeNotifier.value.darkMutedColor,
                        onTap: () {
                          PlayerManager.instance.playSongList(widget.songs!, index);
                        },
                        title: Text(
                          widget.songs![index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              Icons.phone_android_rounded,
                              size: 16,
                              color: _themeNotifier.value.lightMutedColor,
                            ),
                            const Padding(padding: EdgeInsets.all(4.0)),
                            Expanded(
                                child: Text(
                                  '${widget.songs![index].artist ?? "Unknown Artist"} - ${widget.songs![index].album ?? "Unknown Album"}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                          ],
                        ),
                        trailing: IconButton(
                            color: _themeNotifier.value.lightMutedColor,
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz)),
                      );
                    });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              )
                  : ValueListenableBuilder<List<AudioModel>>(
                  valueListenable: _songListManager.miniSongListNotifier,
                  builder: (_, list, __) {
                    //convert items to format for AZList
                    return Material(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: ListView.separated(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ValueListenableBuilder<CurrentSongState>(valueListenable: PlayerManager.instance.currentSongNotifier, builder: (_, currentSongState, __){
                            AudioModel? currentSong = currentSongState.song;
                            return ListTile(
                              tileColor: currentSong?.uri == list[index].uri ? _themeNotifier.value.mutedColor : _themeNotifier.value.darkMutedColor,
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
                                    color: _themeNotifier.value.lightMutedColor,
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
                                  color: _themeNotifier.value.lightMutedColor,
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
}
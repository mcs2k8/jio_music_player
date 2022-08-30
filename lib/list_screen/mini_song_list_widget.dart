import 'package:flutter/material.dart';
import 'package:music_player/player_manager.dart';
import 'package:music_player/song_list_manager.dart';
import 'package:music_player/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniSongListWidget extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final int? artistId;
  final int? albumId;

  const MiniSongListWidget(
      {Key? key,
        required ThemeNotifier this.themeNotifier, this.artistId, this.albumId})
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
    _songListManager.searchSongs(widget.artistId, widget.albumId);
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
              Padding(padding: EdgeInsets.all(4.0)),
              Expanded(child: Text('Sync to Cloud')),
              Switch(value: false, onChanged: (isEnabled) {}),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: _themeNotifier.value.lightMutedColor,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_rounded),
                        Padding(padding: EdgeInsets.all(2.0)),
                        ValueListenableBuilder<List<AudioModel>>(
                            valueListenable: _songListManager.miniSongListNotifier,
                            builder: (_, list, __) {
                              return Text('Play all (${list.length})');
                            })
                      ],
                    )),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
            ],
          ),
          Expanded(
              child: ValueListenableBuilder<List<AudioModel>>(
                  valueListenable: _songListManager.songListNotifier,
                  builder: (_, list, __) {
                    //convert items to format for AZList
                    return ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // tileColor: ,
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
                              Padding(padding: EdgeInsets.all(4.0)),
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
                              icon: Icon(Icons.more_horiz)),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
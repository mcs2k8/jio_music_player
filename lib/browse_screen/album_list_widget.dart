import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/album_details_screen.dart';
import 'package:music_player/browse_screen/list_tiles.dart';
import 'package:music_player/models/object_classes.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumListWidget extends StatefulWidget {

  const AlbumListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AlbumListWidget> createState() => _AlbumListWidgetState();
}

class _AlbumListWidgetState extends State<AlbumListWidget> {
  late final LocalSongManager _artistListManager;
  late final ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _artistListManager = LocalSongManager.instance;
    _themeNotifier = ThemeManager.instance.themeNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ValueListenableBuilder<List<AlbumModel>>(
                  valueListenable: _artistListManager.albumListNotifier,
                  builder: (_, list, __) {
                    List<AzAlbumItem> items = list
                        .map((album) => AzAlbumItem(
                            albumModel: album,
                            tag: album.album.substring(0, 1).toUpperCase()))
                        .toList();
                    return AzListView(
                      indexBarOptions: IndexBarOptions(
                          textStyle: TextStyle(
                              fontSize: 12.0,
                              color: _themeNotifier.value.lightMutedColor)),
                      data: items,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return AlbumTile(list[index]);
                      },
                      // separatorBuilder: (BuildContext context, int index) {
                      //   return const Divider();
                      // },
                    );
                  }))
        ],
      ),
    );
  }
}

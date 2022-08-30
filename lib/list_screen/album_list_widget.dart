import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:music_player/object_classes.dart';
import 'package:music_player/song_list_manager.dart';
import 'package:music_player/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumListWidget extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const AlbumListWidget(
      {Key? key, required this.themeNotifier,})
      : super(key: key);

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
    _themeNotifier = widget.themeNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextButton(
          //           onPressed: () {},
          //           style: TextButton.styleFrom(
          //             primary: _themeNotifier.value.lightMutedColor,
          //           ),
          //           child: Row(
          //             children: [
          //               Icon(Icons.play_circle_rounded),
          //               Padding(padding: EdgeInsets.all(2.0)),
          //               ValueListenableBuilder<List<ArtistModel>>(
          //                   valueListenable:
          //                       _artistListManager.artistListNotifier,
          //                   builder: (_, list, __) {
          //                     return Text('Play all (${list.length})');
          //                   })
          //             ],
          //           )),
          //     ),
          //     IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
          //   ],
          // ),
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
                        int amountOfTracks = list[index].numOfSongs;
                        return ListTile(
                          leading: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(25), // Image radius
                              child: QueryArtworkWidget(
                                type: ArtworkType.ALBUM,
                                id: list[index].id,
                                nullArtworkWidget:
                                QueryArtworkWidget(
                                    id: list[index].artistId ?? 0,
                                    type: ArtworkType.ARTIST,
                                nullArtworkWidget: Image.asset('assets/vinyl.png'),),
                              ),
                            ),
                          ),
                          onTap: () {},
                          title: Text(
                            list[index].album,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '$amountOfTracks song${amountOfTracks > 1 ? "s" : ""}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
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
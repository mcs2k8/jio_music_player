import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/object_classes.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'album_details_screen.dart';

class MiniAlbumListWidget extends StatefulWidget {
  final String? artistId;

  const MiniAlbumListWidget({
    Key? key,
    this.artistId
  }) : super(key: key);

  @override
  State<MiniAlbumListWidget> createState() => _MiniAlbumListWidgetState();
}

class _MiniAlbumListWidgetState extends State<MiniAlbumListWidget> {
  late final LocalSongManager _mediaListManager;

  @override
  void initState() {
    super.initState();
    _mediaListManager = LocalSongManager.instance;
    _mediaListManager.searchAlbums(widget.artistId);
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
                  valueListenable: _mediaListManager.miniAlbumListNotifier,
                  builder: (_, list, __) {
                    List<AzAlbumItem> items = list
                        .map((album) => AzAlbumItem(
                            albumModel: album,
                            tag: album.album.substring(0, 1).toUpperCase()))
                        .toList();
                    return ListView.builder(
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
                                nullArtworkWidget: list[index] != null &&
                                        list[index].artistId != null
                                    ? QueryArtworkWidget(
                                        id: list[index].artistId ?? 0,
                                        type: ArtworkType.ARTIST,
                                        nullArtworkWidget:
                                            Image.asset('assets/vinyl.png'),
                                      )
                                    : Image.asset('assets/vinyl.png'),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return AlbumDetailsScreen(album: list[index],);
                            }));
                          },
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

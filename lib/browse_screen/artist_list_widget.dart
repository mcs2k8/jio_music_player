import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/artist_details_screen.dart';
import 'package:music_player/models/object_classes.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistListWidget extends StatefulWidget {

  const ArtistListWidget(
      {Key? key})
      : super(key: key);

  @override
  State<ArtistListWidget> createState() => _ArtistListWidgetState();
}

class _ArtistListWidgetState extends State<ArtistListWidget> {
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
              child: ValueListenableBuilder<List<ArtistModel>>(
                  valueListenable: _artistListManager.artistListNotifier,
                  builder: (_, list, __) {
                    List<AzArtistItem> items = list
                        .map((artist) => AzArtistItem(
                        artistModel: artist,
                        tag: artist.artist.substring(0, 1).toUpperCase()))
                        .toList();
                    return AzListView(
                      indexBarOptions: IndexBarOptions(
                          textStyle: TextStyle(
                              fontSize: 12.0,
                              color: _themeNotifier.value.lightMutedColor)),
                      data: items,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        int amountOfTracks = list[index].numberOfTracks ?? 0;
                        return ListTile(
                          leading: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(25), // Image radius
                              child: list[index] != null && list[index].id != null ? QueryArtworkWidget(
                                type: ArtworkType.ARTIST,
                                id: list[index].id,
                                nullArtworkWidget: Image.asset('assets/vinyl.png'),
                              ) : Image.asset('assets/vinyl.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ArtistDetailsScreen(artist: list[index], themeNotifier: _themeNotifier,);
                            }));
                          },
                          title: Text(
                            list[index].artist,
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
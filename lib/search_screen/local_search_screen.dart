import 'package:flutter/material.dart';
import 'package:music_player/browse_screen/mini_song_list_widget.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';

import '../browse_screen/player_stripe.dart';

class LocalSearchScreen extends StatelessWidget {
  String search = '';

  @override
  Widget build(BuildContext context) {
    LocalSongManager.instance.miniSongListNotifier.value = SearchResultsState([], [], []);
    if (search.isNotEmpty) LocalSongManager.instance.searchSongsArtistsAlbums(search);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: ThemeManager.instance.themeNotifier.value.lightVibrantColor,
          decoration: InputDecoration(
            focusColor: ThemeManager.instance.themeNotifier.value.lightMutedColor,
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeManager.instance.themeNotifier.value.lightVibrantColor)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeManager.instance.themeNotifier.value.lightMutedColor)),
            hintText: "Search songs on your phone...",
          ),
          onChanged: (text) {
            search = text;
            LocalSongManager.instance.searchSongsArtistsAlbums(text);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MiniSongListWidget(),),
          // Expanded(
          //     child: ValueListenableBuilder<SearchResultsState>(
          //         valueListenable: LocalSongManager.instance.miniSongListNotifier,
          //         builder: (_, searchResultsState, __) {
          //           //convert items to format for AZList
          //           return Material(
          //             clipBehavior: Clip.hardEdge,
          //             color: Colors.transparent,
          //             child: ListView.separated(
          //               itemCount: searchResultsState.songs.length,
          //               itemBuilder: (context, index) {
          //                 return ValueListenableBuilder<CurrentSongState>(valueListenable: PlayerManager.instance.currentSongNotifier, builder: (_, currentSong, __){
          //                   return ListTile(
          //                     tileColor: currentSong.song?.uri == searchResultsState.songs[index].uri ? widget.themeNotifier.value.mutedColor : widget.themeNotifier.value.darkMutedColor,
          //                     onTap: () {
          //                       PlayerManager.instance.playSongList(searchResultsState.songs, index);
          //                     },
          //                     title: Text(
          //                       searchResultsState.songs[index].title,
          //                       maxLines: 1,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                     subtitle: Row(
          //                       children: [
          //                         Icon(
          //                           Icons.phone_android_rounded,
          //                           size: 16,
          //                           color: widget.themeNotifier.value.lightMutedColor,
          //                         ),
          //                         const Padding(padding: EdgeInsets.all(4.0)),
          //                         Expanded(
          //                             child: Text(
          //                               '${searchResultsState.songs[index].artist ?? "Unknown Artist"} - ${searchResultsState.songs[index].album ?? "Unknown Album"}',
          //                               overflow: TextOverflow.ellipsis,
          //                               maxLines: 1,
          //                             ))
          //                       ],
          //                     ),
          //                     trailing: IconButton(
          //                         color: widget.themeNotifier.value.lightMutedColor,
          //                         onPressed: () {},
          //                         icon: const Icon(Icons.more_horiz)),
          //                   );
          //                 });
          //               },
          //               separatorBuilder: (BuildContext context, int index) {
          //                 return const Divider();
          //               },
          //             ),
          //           );
          //         })),
          PlayerStripe(themeNotifier: ThemeManager.instance.themeNotifier,)
        ],
      ),
    );
  }

  @override
  void initState() {

  }
}

import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:music_player/notifiers/current_song_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'edit_song_list_screen.dart';
import 'list_tiles.dart';

class MiniSongListWidget extends StatefulWidget {
  final String? artist;
  final String? album;
  final List<AudioModel>? songs;
  final bool isPlaylist;
  final int playlistKey;

  MiniSongListWidget({Key? key, this.artist, this.album, this.songs, this.isPlaylist = false, this.playlistKey = -1})
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
    _themeNotifier = ThemeManager.instance.themeNotifier;
    if (widget.artist != null || widget.album != null) {
      _songListManager.searchSongs(widget.artist, widget.album);
    }
  }

  @override
  void dispose() {
    LocalSongManager.instance.miniSongListNotifier.value = SearchResultsState([], [], []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ValueListenableBuilder<SearchResultsState>(
          valueListenable: _songListManager.miniSongListNotifier,
          builder: (_, searchResultsState, __) {
            //build list here first
            List<Widget> listView = [];
            if (widget.songs != null){
              widget.songs!.removeWhere((element) => LocalSongManager.instance.songIdsToRemove.contains(element.id));
              for (AudioModel i in widget.songs! ){
                int index = widget.songs!.indexOf(i);
                listView.add(ValueListenableBuilder<CurrentSongState>(
                    valueListenable: PlayerManager
                        .instance.currentSongNotifier,
                    builder: (_, currentSongState, __) {
                      AudioModel? currentSong =
                          currentSongState.song;
                      return SongTile(
                          currentSong, widget.songs![index],
                              () {
                            PlayerManager.instance.playSongList(
                                widget.songs!, index,
                                needsReloadOfSongs: true);
                          }, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditSongListScreen(
                                      songs: widget.songs!,
                                      selectedIndexes: {index},
                                      isPlaylistEdit: widget.isPlaylist,
                                      playlistKey: widget.playlistKey,
                                    )));
                      });
                    }));
              }
            }
            for (AudioModel i in searchResultsState.songs){
              int index = searchResultsState.songs.indexOf(i);
              listView.add(ValueListenableBuilder<CurrentSongState>(
                  valueListenable: PlayerManager
                      .instance.currentSongNotifier,
                  builder: (_, currentSongState, __) {
                    AudioModel? currentSong =
                        currentSongState.song;
                    return SongTile(
                        currentSong, searchResultsState.songs[index],
                            () {
                          PlayerManager.instance.playSongList(
                              searchResultsState.songs, index,
                              needsReloadOfSongs: true);
                        }, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditSongListScreen(
                                    songs: searchResultsState
                                        .songs,
                                    selectedIndexes: {index},
                                    isPlaylistEdit: widget.isPlaylist,
                                    playlistKey: widget.playlistKey,
                                  )));
                    });
                  }));
            }
            for (ArtistModel i in searchResultsState.artists){
              listView.add(ArtistTile(i));
            }
            for (AlbumModel i in searchResultsState.albums){
              listView.add(AlbumTile(i));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              PlayerManager.instance.playSongList(
                                  widget.songs ?? searchResultsState.songs, 0,
                                  needsReloadOfSongs: true);
                            },
                            style: TextButton.styleFrom(
                              primary: _themeNotifier.value.lightMutedColor,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.play_circle_rounded),
                                const Padding(padding: EdgeInsets.all(2.0)),
                                Text(
                                    'Play all (${widget.songs?.length ?? searchResultsState.songs.length})')
                              ],
                            ))),
                    IconButton(onPressed: () {}, icon: Icon(Icons.checklist))
                  ],
                ),
                Expanded(
                    child: Material(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.transparent,
                            child: ListView(
                              children: listView,
                            ),
                          )
                        )
              ],
            );
          }),
    );
  }
}

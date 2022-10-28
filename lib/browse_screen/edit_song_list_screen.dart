import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class EditSongListScreen extends StatefulWidget {
  final List<AudioModel> songs;
  final Set<int> selectedIndexes;
  final bool isPlaylistEdit;
  final int playlistKey;

  const EditSongListScreen(
      {Key? key, required this.songs, required this.selectedIndexes, this.isPlaylistEdit = false, this.playlistKey = -1})
      : super(key: key);

  @override
  State<EditSongListScreen> createState() => _EditSongListScreenState();
}

class _EditSongListScreenState extends State<EditSongListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.selectedIndexes.length} item${widget.selectedIndexes.length > 1 ? 's' : ''} selected"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.separated(
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: CheckboxListTile(
                  value: widget.selectedIndexes.contains(index) ? true : false,
                  onChanged: (isChecked) {
                    print("isChecked: $isChecked");
                    if (isChecked == null) {
                      return;
                    }
                    if (isChecked) {
                      widget.selectedIndexes.add(index);
                    } else {
                      widget.selectedIndexes.remove(index);
                    }
                    setState(() {});
                  },
                  title: Text(
                    widget.songs[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.phone_android_rounded,
                        size: 16,
                        color: ThemeManager
                            .instance.themeNotifier.value.lightMutedColor,
                      ),
                      const Padding(padding: EdgeInsets.all(4.0)),
                      Expanded(
                          child: Text(
                        '${widget.songs[index].artist ?? "Unknown Artist"} - ${widget.songs[index].album ?? "Unknown Album"}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ))
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          )),
          Material(
            elevation: 10,
            color: ThemeManager.instance.themeNotifier.value.darkVibrantColor,
            child: Row(
              children: [
                !widget.isPlaylistEdit?
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (widget.selectedIndexes.isNotEmpty) {
                          print("playing songs");
                          List<AudioModel> songsToPlay = [];
                          for (var index in widget.selectedIndexes){
                            songsToPlay.add(widget.songs[index]);
                          }
                          PlayerManager.instance.playSongList(songsToPlay, 0);
                          //consider going back to the previous screen
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: "Playing songs");
                        }
                      },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => widget.selectedIndexes.isNotEmpty
                                  ? ThemeManager
                                  .instance.themeNotifier.value.lightMutedColor
                                  : ThemeManager
                                  .instance.themeNotifier.value.mutedColor)),
                      child: Column(
                        children: const [
                          Icon(Icons.play_circle_rounded),
                          Text(
                            "Play",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    )) : Container(),
                Expanded(
                    child: TextButton(
                  onPressed: () async {
                    if (widget.selectedIndexes.isNotEmpty) {
                      print("adding to favourites");
                      for (var index in widget.selectedIndexes){
                        LocalSongManager.instance.addToFavourites(widget.songs[index]);
                      }
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Added songs to favourites");
                    }
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => widget.selectedIndexes.isNotEmpty
                              ? ThemeManager
                                  .instance.themeNotifier.value.lightMutedColor
                              : ThemeManager
                                  .instance.themeNotifier.value.mutedColor)),
                  child: Column(
                    children: const [
                      Icon(Icons.favorite_border_rounded),
                      Text(
                        "Add to favourites",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () async {
                    if (widget.selectedIndexes.isNotEmpty) {
                      print("adding to playlist");
                      int playlist = await showDialog(context: context, builder: (context){
                        List<Widget> options = [];
                        for (PlaylistEntity playlist in LocalSongManager.instance.playlistListNotifier.value.playlists){
                          options.add(SimpleDialogOption(
                            child: Text(playlist.playlistName),
                            onPressed: () {
                              Navigator.pop(context, playlist.key);
                            },
                          ));
                        }
                        return SimpleDialog(
                          backgroundColor: ThemeManager.instance.themeNotifier.value.mutedColor,
                          titlePadding: EdgeInsets.all(16),
                          title: Text("Choose Playlist to add to"),
                          children: options,
                        );
                      });
                      //show progress dialog
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              Text("Adding to playlist..."),
                            ],
                          ),
                        );
                      });
                      List<AudioModel> songsToAdd = [];
                      for (var index in widget.selectedIndexes){
                        songsToAdd.add(widget.songs[index]);
                      }
                      await LocalSongManager.instance.addToPlaylist(songsToAdd, playlist);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Added to playlist");
                    }
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => widget.selectedIndexes.isNotEmpty
                              ? ThemeManager
                                  .instance.themeNotifier.value.lightMutedColor
                              : ThemeManager
                                  .instance.themeNotifier.value.mutedColor)),
                  child: Column(
                    children: const [
                      Icon(Icons.playlist_add),
                      Text(
                        "Add to playlist",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                )),
                widget.isPlaylistEdit?
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: ThemeManager.instance.themeNotifier.value.darkMutedColor,
                                titlePadding: EdgeInsets.all(16),
                                contentPadding: EdgeInsets.all(16),
                                content: Text("Delete items?"),
                                actions: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: Text("CANCEL")),
                                    TextButton(onPressed: () async {
                                      Navigator.pop(context);
                                      if (widget.selectedIndexes.isNotEmpty) {
                                        print("deleting songs from playlist");
                                        List<int> songsToDelete = [];
                                        for (var index in widget.selectedIndexes){
                                          songsToDelete.add(widget.songs[index].id);
                                        }
                                        LocalSongManager.instance.removeFromPlaylist(songsToDelete, widget.playlistKey);
                                        // PlayerManager.instance.playSongList(songsToDelete, 0);
                                        //consider going back to the previous screen
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(msg: "Removed songs from playlist");
                                      }
                                    }, child: Text("OK")),
                                ],
                              );
                            });




                      },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => widget.selectedIndexes.isNotEmpty
                                  ? ThemeManager
                                  .instance.themeNotifier.value.lightMutedColor
                                  : ThemeManager
                                  .instance.themeNotifier.value.mutedColor)),
                      child: Column(
                        children: const [
                          Icon(Icons.delete_rounded),
                          Text(
                            "Delete",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    )) : Container(),

                Expanded(
                    child: TextButton(
                  onPressed: () {
                    if (widget.selectedIndexes.length < widget.songs.length) {
                      widget.selectedIndexes.addAll(
                          widget.songs.map((e) => widget.songs.indexOf(e)));
                    } else {
                      widget.selectedIndexes.removeAll(
                          widget.songs.map((e) => widget.songs.indexOf(e)));
                    }
                    setState(() {});
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => ThemeManager
                              .instance.themeNotifier.value.lightMutedColor)),
                  child: Column(
                    children: const [
                      Icon(Icons.library_add_check_outlined),
                      Text(
                        "Select all",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

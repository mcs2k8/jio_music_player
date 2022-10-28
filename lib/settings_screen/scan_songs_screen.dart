import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:music_player/managers/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScanSongsScreen extends StatefulWidget {
  const ScanSongsScreen({Key? key}) : super(key: key);

  @override
  State<ScanSongsScreen> createState() => _ScanSongsScreenState();
}

class _ScanSongsScreenState extends State<ScanSongsScreen> {
  late String notification;
  bool shouldShowProgressBar = false;
  bool shouldShowListOfFolders = false;
  bool isComplete = false;
  List<String> folders = [];
  Map<String, String> foldersToRemove = {};
  double value = 0.0;
  String buttonValue = "SCAN";

  @override
  void initState() {
    notification =
        "We will scan your phone and add all the playable music to Jio Music";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Phone for songs"),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/search.png',
                    width: shouldShowListOfFolders ? 130 : 200),
                SizedBox(
                  height: 16,
                ),
                Text(
                  notification,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 32,
                ),
                shouldShowProgressBar
                    ? LinearProgressIndicator(
                        value: value,
                      )
                    : Container(),
                shouldShowProgressBar
                    ? SizedBox(
                        height: 32,
                      )
                    : Container(),
                !shouldShowListOfFolders
                    ? Container()
                    : Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: folders.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(folders[index]),
                                value: !foldersToRemove
                                    .containsKey(folders[index]),
                                onChanged: (isChecked) {
                                  if (isChecked != null && isChecked) {
                                    foldersToRemove.remove(folders[index]);
                                  } else {
                                    foldersToRemove[folders[index]] =
                                        folders[index];
                                  }
                                  setState(() {});
                                },
                              );
                            }),
                      ),
                SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (shouldShowListOfFolders) {
                        saveSongValues();
                      } else if (shouldShowProgressBar) {
                      } else if (isComplete) {
                        Navigator.pop(context);
                      } else {
                        scanSongs();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        buttonValue,
                        style: TextStyle(
                            fontSize: 16,
                            color: ThemeManager
                                .instance.themeNotifier.value.darkMutedColor),
                      ),
                    )),
                !shouldShowListOfFolders
                    ? SizedBox(
                        height: 44,
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanSongs() async {
    setState(() {
      notification = "Querying new song list";
      shouldShowListOfFolders = false;
      shouldShowProgressBar = false;
      isComplete = false;
    });
    await LocalSongManager.instance.querySongs();
    List<AudioModel> songs = LocalSongManager.instance.songListNotifier.value;
    setState(() {
      shouldShowListOfFolders = false;
      shouldShowProgressBar = true;
      isComplete = false;
      notification = "Filtering ${songs.length} songs";
      value = 0;
    });
    List<AudioModel> songsToRemove = [];
    for (int i = 0; i < songs.length; i++) {
      AudioModel song = songs[i];
      setState(() {
        notification = "Processing song ${i + 1} out of ${songs.length}";
        shouldShowProgressBar = true;
        value = i / songs.length;
        isComplete = false;
      });
      File songFile = File(song.data);
      print("Song ${song.title} exists: ${songFile.existsSync()}");
      if (!songFile.existsSync()) {
        songsToRemove.add(song);
      }
    }
    print(
        "${songs.length - songsToRemove.length} out of ${songs.length} exist");
    LocalSongManager.instance.songIdsToRemove =
        songsToRemove.map((e) => e.id).toList();
    PlayerManager.instance.savePlayerSettings();
    setState(() {
      isComplete = false;
      shouldShowProgressBar = false;
      notification = "Finished scanning songs";
    });
    await LocalSongManager.instance.querySongs();

    songs = LocalSongManager.instance.fullSongList;
    //get all folders with the songs
    Map<String, String> folderMap = {};
    for (AudioModel song in songs) {
      File songFile = File(song.data);
      folderMap[songFile.parent.path] = songFile.parent.path;
    }
    foldersToRemove = {};
    LocalSongManager.instance.foldersToRemove.forEach((element) {
      foldersToRemove[element] = element;
    });
    setState(() {
      shouldShowListOfFolders = true;
      shouldShowProgressBar = false;
      isComplete = false;
      folders = folderMap.keys.toList();
      notification = "Which folders would you like to keep?";
      buttonValue = "KEEP THESE";
    });
  }

  Future<void> saveSongValues() async {
    print("IDS to remove: ${LocalSongManager.instance.songIdsToRemove.length}");
    LocalSongManager.instance.foldersToRemove = foldersToRemove.keys.toList();
    await LocalSongManager.instance.querySongs();
    // await LocalSongManager.instance.queryPlaylists();
    List<AudioModel> songs = LocalSongManager.instance.songListNotifier.value;
    //filter out artists
    setState(() {
      shouldShowListOfFolders = false;
      shouldShowProgressBar = true;
      value = 0.3;
      notification = "Please wait... Rebuilding artist library";
    });
    List<AudioModel> initialSongList = await OnAudioQuery().querySongs();
    List<AudioModel> songsToRemove = initialSongList.toList();
    songsToRemove
        .removeWhere((e) => songs.any((element) => element.id == e.id));
    List<ArtistModel> artistList = await OnAudioQuery().queryArtists();
    List<ArtistModel> artistsToRemove = [];
    for (ArtistModel artist in artistList) {
      setState(() {
        notification =
            "Please wait... Rebuilding artist library\n${artist.artist}";
      });
      List<AudioModel> songs = await OnAudioQuery().querySongs(
          filter: MediaFilter.forAudios(toQuery: {
        MediaColumns.Audio.ARTIST_ID: [artist.id.toString()]
      }));
      songs.removeWhere(
          (e) => songsToRemove.any((element) => element.id == e.id));
      if (songs.isEmpty) {
        artistsToRemove.add(artist);
      }
    }

    //filter out albums
    setState(() {
      shouldShowListOfFolders = false;
      shouldShowProgressBar = true;
      value = 0.6;
      notification = "Please wait... Rebuilding album library";
    });
    List<AlbumModel> albumsToRemove = [];
    List<AlbumModel> albums = await OnAudioQuery().queryAlbums();
    for (AlbumModel album in albums) {
      setState(() {
        notification =
            "Please wait... Rebuilding album library\n${album.album}";
      });
      List<AudioModel> songs = await OnAudioQuery().querySongs(
          filter: MediaFilter.forAudios(toQuery: {
        MediaColumns.Audio.ALBUM_ID: [album.id.toString()]
      }));
      songs.removeWhere(
          (e) => songsToRemove.any((element) => element.id == e.id));
      if (songs.isEmpty) {
        albumsToRemove.add(album);
      }
    }

    //filter out playlists

    //set values to LocalSongManager
    setState(() {
      shouldShowListOfFolders = false;
      shouldShowProgressBar = true;
      value = 0.9;
      notification = "Please wait... Writing values";
    });
    LocalSongManager.instance.artistIdsToRemove =
        artistsToRemove.map((e) => e.id).toList();
    LocalSongManager.instance.albumIdsToRemove =
        albumsToRemove.map((e) => e.id).toList();
    await LocalSongManager.instance.queryArtists();
    await LocalSongManager.instance.queryAlbums();
    PlayerManager.instance.savePlayerSettings();

    setState(() {
      shouldShowProgressBar = false;
      shouldShowListOfFolders = false;
      isComplete = true;
      buttonValue = "DONE";
      notification =
          "You're all done! You've got a total of ${songs.length} songs. Click DONE to go back.";
    });
  }
}

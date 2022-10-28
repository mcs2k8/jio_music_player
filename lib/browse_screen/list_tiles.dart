import 'package:flutter/material.dart';
import 'package:music_player/managers/song_list_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../managers/player_manager.dart';
import '../managers/theme_manager.dart';
import 'album_details_screen.dart';
import 'artist_details_screen.dart';

class SongTile extends StatelessWidget {
  AudioModel? currentSong;
  AudioModel song;
  Function() onTap;
  Function() onLongPress;

  SongTile(this.currentSong, this.song, this.onTap, this.onLongPress, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      tileColor: currentSong?.uri == song.uri
          ? ThemeManager.instance.themeNotifier.value.mutedColor
          : ThemeManager.instance.themeNotifier.value.darkMutedColor,
      onTap: onTap,
      onLongPress: onLongPress,
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.phone_android_rounded,
            size: 16,
            color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
          ),
          const Padding(padding: EdgeInsets.all(4.0)),
          Expanded(
              child: Text(
            '${song.artist ?? "Unknown Artist"} - ${song.album ?? "Unknown Album"}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ))
        ],
      ),
      trailing: IconButton(
          color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
          onPressed: () {},
          icon: const Icon(Icons.more_horiz)),
    );
  }
}

class ArtistTile extends StatelessWidget {
  ArtistModel artist;
  
  ArtistTile(this.artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int amountOfTracks = artist.numberOfTracks ?? 0;
    return ListTile(
      leading: ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(25), // Image radius
          child: artist != null && artist.id != null
              ? QueryArtworkWidget(
                  type: ArtworkType.ARTIST,
                  id: artist.id,
                  nullArtworkWidget: Image.asset('assets/vinyl.png'),
                )
              : Image.asset('assets/vinyl.png'),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ArtistDetailsScreen(
            artist: artist,
            themeNotifier: ThemeManager.instance.themeNotifier,
          );
        })).then((value) {
          LocalSongManager.instance.miniSongListNotifier.value = SearchResultsState([], [], []);
        });
      },
      title: Text(
        artist.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$amountOfTracks song${amountOfTracks > 1 ? "s" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class AlbumTile extends StatelessWidget {
  AlbumModel album;
  
  AlbumTile(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int amountOfTracks = album.numOfSongs;
    return ListTile(
      leading: ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(25), // Image radius
          child: QueryArtworkWidget(
            type: ArtworkType.ALBUM,
            id: album.id,
            nullArtworkWidget: album != null &&
                album.artistId != null
                ? QueryArtworkWidget(
              id: album.artistId ?? 0,
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
          return AlbumDetailsScreen(album: album);
        })).then((value) {
          LocalSongManager.instance.miniSongListNotifier.value = SearchResultsState([], [], []);
        });
      },
      title: Text(
        album.album,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$amountOfTracks song${amountOfTracks > 1 ? "s" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class WebSongTile extends StatelessWidget {
  AudioModel? currentSong;
  Map song;
  String source;
  Color color;
  Function() onTap;

  WebSongTile(this.currentSong, this.song, this.onTap, this.source, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      tileColor: ThemeManager.instance.themeNotifier.value.darkMutedColor,
      onTap: onTap,
      // onLongPress: onLongPress,
      title: Text(
        song['title'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            "$source",
            style: TextStyle(fontSize: 12, color: color),
          ),
          const Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
              child: Text(
                '${song['artist'] ?? "Unknown Artist"} - ${song['album'] ?? "Unknown Album"}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ))
        ],
      ),
      trailing: IconButton(
          color: ThemeManager.instance.themeNotifier.value.lightMutedColor,
          onPressed: () {},
          icon: const Icon(Icons.more_horiz)),
    );
  }
}


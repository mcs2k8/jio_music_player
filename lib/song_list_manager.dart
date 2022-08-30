import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class LocalSongManager {
  final songListNotifier = ValueNotifier<List<AudioModel>>([]);
  final artistListNotifier = ValueNotifier<List<ArtistModel>>([]);
  final albumListNotifier = ValueNotifier<List<AlbumModel>>([]);
  final playlistListNotifier = ValueNotifier<List<PlaylistModel>>([]);
  //notifiers for search/songs/albums for artist/album
  final miniSongListNotifier = ValueNotifier<List<AudioModel>>([]);
  final miniAlbumListNotifier = ValueNotifier<List<AlbumModel>>([]);

  LocalSongManager._() {
    _init();
  }
  static final instance = LocalSongManager._();

  void _init() async {
    await querySongs();
    await queryArtists();
    await queryAlbums();
    await queryPlaylists();
  }

  Future<void> querySongs() async {
    List<AudioModel> songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs( audioSortType: AudioSortType.DATE_ADDED, orderType: OrderType.DESC_OR_GREATER));
    print("Found ${songs.length} songs");
    songListNotifier.value = songs;
  }

  Future<void> queryArtists() async {
    List<ArtistModel> artists = await OnAudioQuery().queryArtists(filter: MediaFilter.forArtists(artistSortType: ArtistSortType.ARTIST, orderType: OrderType.ASC_OR_SMALLER));
    print("Found ${artists.length} artists");
    artistListNotifier.value = artists;
  }

  Future<void> queryAlbums() async {
    List<AlbumModel> albums = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums(toRemove: {
      MediaColumns.Album.ID: [""]
    }));
    print("Found ${albums.length} albums");
    albumListNotifier.value = albums;
  }

  Future<void> queryPlaylists() async {
    List<PlaylistModel> albums = await OnAudioQuery().queryPlaylists(filter: MediaFilter.forPlaylists(playlistSortType: PlaylistSortType.PLAYLIST, orderType: OrderType.ASC_OR_SMALLER));
    print("Found ${albums.length} playlists");
    // albumListNotifier.value = albums;
  }

  Future<void> searchSongs(int? artistId, int? albumId) async {
    List<AudioModel> songs = [];
    if (artistId != null){
      if (albumId != null){
        songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
          MediaColumns.Artist.ID: [artistId.toString()],
          MediaColumns.Album.ID: [albumId.toString()]
        }));
      }
      songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
        MediaColumns.Artist.ID: [artistId.toString()],
      }));
    }else{
      if (albumId != null){
        songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
          MediaColumns.Album.ID: [albumId.toString()]
        }));
      }
    }
    miniSongListNotifier.value = songs;
  }
}
import 'package:flutter/material.dart';
import 'package:music_player/notifiers/playlists_notifier.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class LocalSongManager {
  final songListNotifier = ValueNotifier<List<AudioModel>>([]);
  final artistListNotifier = ValueNotifier<List<ArtistModel>>([]);
  final albumListNotifier = ValueNotifier<List<AlbumModel>>([]);
  final playlistListNotifier = ValueNotifier<PlaylistState>(PlaylistState());
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
    songs.removeWhere((element) => (element.duration ?? 0) < 100);
    print("Left with ${songs.length} songs");
    songListNotifier.value = songs;
  }

  Future<void> queryArtists() async {
    List<ArtistModel> artists = await OnAudioQuery().queryArtists(filter: MediaFilter.forArtists(artistSortType: ArtistSortType.ARTIST, orderType: OrderType.ASC_OR_SMALLER));
    print("Found ${artists.length} artists");
    artistListNotifier.value = artists;
  }

  Future<void> queryAlbums() async {
    List<AlbumModel> albums = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums());
    print("Found ${albums.length} albums");
    albumListNotifier.value = albums;
  }

  Future<void> queryPlaylists() async {
    List<PlaylistEntity> playlists = await OnAudioRoom().queryPlaylists();
    print("Found ${playlists.length} playlists");
    List<FavoritesEntity> favourites = await OnAudioRoom().queryFavorites(limit: 1000);
    List<LastPlayedEntity> lastPlayed = await OnAudioRoom().queryLastPlayed(limit: 100);
    List<MostPlayedEntity> mostPlayed = await OnAudioRoom().queryMostPlayed(limit: 100);
    PlaylistState playlistState = PlaylistState(
      playlists: playlists,
      favorites: favourites,
      lastPlayed: lastPlayed,
      mostPlayed: mostPlayed
    );
    playlistListNotifier.value = playlistState;
  }

  Future<void> searchSongs(String? artist, String? album) async {
    List<AudioModel> songs = [];
    if (artist != null){
      if (album != null){
        songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
          MediaColumns.Audio.ARTIST_ID: [artist],
          MediaColumns.Audio.ALBUM_ID: [album]
        }));
      }
      songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
        MediaColumns.Audio.ARTIST_ID: [artist],
      }));
    }else{
      if (album != null){
        songs = await OnAudioQuery().querySongs(filter: MediaFilter.forSongs(audioSortType: AudioSortType.TITLE, toQuery: {
          MediaColumns.Audio.ALBUM_ID: [album]
        }));
      }
    }
    miniSongListNotifier.value = songs;
  }

  Future<void> searchAlbums(String? artistId) async {
    List<AlbumModel> albums = [];
    if (artistId != null){

      albums = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums(albumSortType: AlbumSortType.ALBUM, toQuery: {
        MediaColumns.Album.ARTIST_ID: [artistId],
      }));
    }
    miniAlbumListNotifier.value = albums;
  }

  Future<void> searchSongsArtistsAlbums(String query) async {
    List<AudioModel> songsSearch = await OnAudioQuery().querySongs(filter: MediaFilter.forAudios(audioSortType: AudioSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Audio.TITLE: [query]
    }));
    List<AudioModel> artistsSearch = await OnAudioQuery().querySongs(filter: MediaFilter.forAudios(audioSortType: AudioSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Audio.ARTIST: [query]
    }));
    List<AudioModel> albumsSearch = await OnAudioQuery().querySongs(filter: MediaFilter.forAudios(audioSortType: AudioSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Audio.ALBUM: [query]
    }));

    songsSearch.addAll(artistsSearch);
    songsSearch.addAll(albumsSearch);
    miniSongListNotifier.value = songsSearch;
  }
}
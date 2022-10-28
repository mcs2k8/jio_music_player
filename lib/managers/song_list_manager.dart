import 'package:flutter/material.dart';
import 'package:music_player/managers/player_manager.dart';
import 'package:music_player/notifiers/playlists_notifier.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'dart:io';

class LocalSongManager {
  List<AudioModel> fullSongList = [];
  final songListNotifier = ValueNotifier<List<AudioModel>>([]);
  final artistListNotifier = ValueNotifier<List<ArtistModel>>([]);
  final albumListNotifier = ValueNotifier<List<AlbumModel>>([]);
  final playlistListNotifier = ValueNotifier<PlaylistState>(PlaylistState());
  //notifiers for search/songs/albums for artist/album
  final miniSongListNotifier = ValueNotifier<SearchResultsState>(SearchResultsState([], [], []));
  final miniAlbumListNotifier = ValueNotifier<List<AlbumModel>>([]);
  List<int> songIdsToRemove = [];
  List<String> foldersToRemove = [];
  List<int> artistIdsToRemove = [];
  List<int> albumIdsToRemove = [];


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
    print("Found ${songs.length} songs. IDsToRemove: ${songIdsToRemove.length}. FoldersToRemove: ${foldersToRemove.length}");
    songs.removeWhere((element) => (element.duration ?? 0) < 60000);
    print("Left with ${songs.length} songs that are more than 60 seconds long");
    songs.removeWhere((element) =>  songIdsToRemove.contains(element.id));
    print("Left with ${songs.length} songs after removing nonexisting IDs");
    fullSongList = songs.toList();
    songs.removeWhere((element) => foldersToRemove.contains(File(element.data).parent.path));
    print("Left with ${songs.length} songs after removing unwanted folders");
    songListNotifier.value = songs;

  }

  Future<void> queryArtists() async {
    List<ArtistModel> artists = await OnAudioQuery().queryArtists(filter: MediaFilter.forArtists(artistSortType: ArtistSortType.ARTIST, orderType: OrderType.ASC_OR_SMALLER));
    print("Found ${artists.length} artists. IDsToRemove: ${artistIdsToRemove.length}");
    artists.removeWhere((element) => artistIdsToRemove.contains(element.id));
    print("Left with ${artists.length} artists");
    artistListNotifier.value = artists;
  }

  Future<void> queryAlbums() async {
    List<AlbumModel> albums = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums());
    print("Found ${albums.length} albums");
    albums.removeWhere((element) => albumIdsToRemove.contains(element.id));
    print("Left with ${albums.length} albums");
    albumListNotifier.value = albums;
  }

  Future<void> queryPlaylists() async {
    //make sure playlists are created
    await OnAudioRoom().createPlaylist('energizing');
    await OnAudioRoom().createPlaylist('relaxing');
    await OnAudioRoom().createPlaylist('romance');
    await OnAudioRoom().createPlaylist('sleep');

    List<PlaylistEntity> playlists = await OnAudioRoom().queryPlaylists();
    //remove songs that dont exist
    // for (PlaylistEntity playlist in playlists){
    //   for (SongEntity song in playlist.playlistSongs){
    //     if (songIdsToRemove.contains(song.id)){
    //       await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, song.id, playlistKey: playlist.key);
    //     }
    //   }
    // }
    List<FavoritesEntity> favourites = await OnAudioRoom().queryFavorites(limit: 1000);
    //remove songs that dont exist
    // for (SongEntity song in favourites.reversed){
    //   if (songIdsToRemove.contains(song.id)){
    //     await OnAudioRoom().deleteFrom(RoomType.FAVORITES, song.id);
    //   }
    // }
    List<LastPlayedEntity> lastPlayed = await OnAudioRoom().queryLastPlayed(limit: 100);
    //remove songs that dont exist
    // for (SongEntity song in lastPlayed.reversed){
    //   if (songIdsToRemove.contains(song.id)){
    //     await OnAudioRoom().deleteFrom(RoomType.LAST_PLAYED, song.id);
    //   }
    // }
    List<MostPlayedEntity> mostPlayed = await OnAudioRoom().queryMostPlayed(limit: 100);
    //remove songs that dont exist
    // for (SongEntity song in mostPlayed.reversed){
    //   if (songIdsToRemove.contains(song.id)){
    //     await OnAudioRoom().deleteFrom(RoomType.MOST_PLAYED, song.id);
    //   }
    // }
    PlaylistEntity energizing = playlists.removeAt(playlists.indexWhere((element) => element.playlistName == 'energizing'));
    PlaylistEntity relaxing = playlists.removeAt(playlists.indexWhere((element) => element.playlistName == 'relaxing'));
    PlaylistEntity romance = playlists.removeAt(playlists.indexWhere((element) => element.playlistName == 'romance'));
    PlaylistEntity sleep = playlists.removeAt(playlists.indexWhere((element) => element.playlistName == 'sleep'));
    PlaylistState playlistState = PlaylistState(
      playlists: playlists,
      favorites: favourites,
      lastPlayed: lastPlayed,
      mostPlayed: mostPlayed,
      energizing: energizing,
      relaxing: relaxing,
      romance: romance,
      sleep: sleep
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
    miniSongListNotifier.value = SearchResultsState(songs, [], []);
  }

  Future<void> searchAlbums(String? artistId) async {
    //TODO: make sure there are no SQL crashes when ' symbol is present
    List<AlbumModel> albums = [];
    if (artistId != null){
      artistId = artistId.replaceAll("'", "''");
      albums = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums(toQuery: {
        MediaColumns.Album.ARTIST: [artistId]
      }));
    }
    miniAlbumListNotifier.value = albums;
  }

  Future<void> searchSongsArtistsAlbums(String query) async {
    if (query.isEmpty){
      miniSongListNotifier.value = SearchResultsState([], [], []);
      return;
    }
    List<AudioModel> songsSearch = await OnAudioQuery().querySongs(filter: MediaFilter.forAudios(audioSortType: AudioSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Audio.TITLE: [query]
    }));
    List<ArtistModel> artistsSearch = await OnAudioQuery().queryArtists(filter: MediaFilter.forArtists(artistSortType: ArtistSortType.ARTIST, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Artist.ARTIST: [query]
    }));
    List<AlbumModel> albumsSearch = await OnAudioQuery().queryAlbums(filter: MediaFilter.forAlbums(albumSortType: AlbumSortType.ALBUM, orderType: OrderType.ASC_OR_SMALLER, toQuery: {
      MediaColumns.Album.ALBUM: [query]
    }));
    print("found ${songsSearch.length} songs, ${artistsSearch.length} artists, ${albumsSearch.length} albums");
    miniSongListNotifier.value = SearchResultsState(songsSearch, artistsSearch, albumsSearch);
  }

  Future<void> addToFavourites(AudioModel? song) async{
    if (song != null){
      await OnAudioRoom().addTo(RoomType.FAVORITES, song.getMap.toFavoritesEntity());
    }else if(PlayerManager.instance.currentSongNotifier.value.song != null){
      await OnAudioRoom().addTo(RoomType.FAVORITES, PlayerManager.instance.currentSongNotifier.value.song!.getMap.toFavoritesEntity());
    }
    await queryPlaylists();
  }

  Future<void> removeFromFavourites(int? id) async {
    if (id != null){
      await OnAudioRoom().deleteFrom(RoomType.FAVORITES, id);
    }else if(PlayerManager.instance.currentSongNotifier.value.song != null){
      await OnAudioRoom().deleteFrom(RoomType.FAVORITES, PlayerManager.instance.currentSongNotifier.value.song!.id);
    }
    await queryPlaylists();
  }

  Future<bool> createPlaylist(String? name) async{
    if (name != null && name.isNotEmpty){
      int? result = await OnAudioRoom().createPlaylist(name);
      if (result != 0){
        queryPlaylists();
        //print("hi");
        return true;
      }
    }
    return false;
  }

  Future<void> addToLastAndMostPlayed() async {
    LastPlayedEntity? lastPlayedSong = PlayerManager.instance.currentSongNotifier.value.song?.getMap
        .toLastPlayedEntity(DateTime.now().millisecondsSinceEpoch);
    MostPlayedEntity? mostPlayedSong = PlayerManager.instance.currentSongNotifier.value.song?.getMap
        .toMostPlayedEntity(DateTime.now().millisecondsSinceEpoch);
    //check if song exists in mostPlayed
    if (mostPlayedSong != null){
      MostPlayedEntity? songInList =
      await OnAudioRoom().queryFromMostPlayed(mostPlayedSong.key);
      if (songInList != null) {
        mostPlayedSong = songInList;
        mostPlayedSong.playCount++;
      }
    }
    await OnAudioRoom().addTo(RoomType.LAST_PLAYED, lastPlayedSong,
        ignoreDuplicate: true);
    await OnAudioRoom().addTo(RoomType.MOST_PLAYED, mostPlayedSong,
        ignoreDuplicate: true);
    queryPlaylists();
  }

  Future<List<int?>> addToPlaylist(List<AudioModel> song, int key) async {
    List<int?> results = await OnAudioRoom().addAllTo(RoomType.PLAYLIST, song.map((e) => e.getMap.toSongEntity()).toList(), playlistKey: key);
    queryPlaylists();
    return results;
  }

  Future<void> deletePlaylist(int key) async {
    await OnAudioRoom().deletePlaylist(key);
    queryPlaylists();
  }

  Future<void> removeFromPlaylist(List<int> keys, int playlist) async {
    for (var key in keys){
      await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, key, playlistKey: playlist);
    }
    await queryPlaylists();
  }

  Future<void> removeFromAllFavourites(int id) async {
    await OnAudioRoom().deleteFrom(RoomType.FAVORITES, id);
    if (playlistListNotifier.value.energizing != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, id, playlistKey: playlistListNotifier.value.energizing?.key);
    if (playlistListNotifier.value.relaxing != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, id, playlistKey: playlistListNotifier.value.relaxing?.key);
    if (playlistListNotifier.value.romance != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, id, playlistKey: playlistListNotifier.value.romance?.key);
    if (playlistListNotifier.value.sleep != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, id, playlistKey: playlistListNotifier.value.sleep?.key);
    await queryPlaylists();
  }

  Future<void> addToFavoritesPlaylist(AudioModel audio, String playlistName) async {
    //add to favorites
    await OnAudioRoom().addTo(RoomType.FAVORITES, audio.getMap.toFavoritesEntity());
    //make sure song is not present in other playlists
    if (playlistListNotifier.value.energizing != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, audio.id, playlistKey: playlistListNotifier.value.energizing?.key);
    if (playlistListNotifier.value.relaxing != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, audio.id, playlistKey: playlistListNotifier.value.relaxing?.key);
    if (playlistListNotifier.value.romance != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, audio.id, playlistKey: playlistListNotifier.value.romance?.key);
    if (playlistListNotifier.value.sleep != null) await OnAudioRoom().deleteFrom(RoomType.PLAYLIST, audio.id, playlistKey: playlistListNotifier.value.sleep?.key);
    //add song to the right playlist
    switch (playlistName){
      case 'energizing':
        await OnAudioRoom().addTo(RoomType.PLAYLIST, audio.getMap.toSongEntity(), playlistKey: playlistListNotifier.value.energizing!.key);
        break;
      case 'relaxing':
        await OnAudioRoom().addTo(RoomType.PLAYLIST, audio.getMap.toSongEntity(), playlistKey: playlistListNotifier.value.relaxing!.key);
        break;
      case 'romance':
        await OnAudioRoom().addTo(RoomType.PLAYLIST, audio.getMap.toSongEntity(), playlistKey: playlistListNotifier.value.romance!.key);
        break;
      case 'sleep':
        await OnAudioRoom().addTo(RoomType.PLAYLIST, audio.getMap.toSongEntity(), playlistKey: playlistListNotifier.value.sleep!.key);
        break;
    }
    await queryPlaylists();
  }
}

class SearchResultsState {
  final List<AudioModel> songs;
  final List<ArtistModel> artists;
  final List<AlbumModel> albums;

  SearchResultsState(this.songs, this.artists, this.albums);
}
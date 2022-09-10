import 'package:flutter/material.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistState {
  List<PlaylistEntity> playlists = [];
  List<FavoritesEntity> favorites = [];
  List<LastPlayedEntity> lastPlayed = [];
  List<MostPlayedEntity> mostPlayed = [];

  PlaylistState(
  {this.playlists = const [], this.favorites = const [], this.lastPlayed = const [], this.mostPlayed = const []});
}
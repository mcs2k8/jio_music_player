import 'package:flutter/material.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistState {
  List<PlaylistEntity> playlists = [];
  List<FavoritesEntity> favorites = [];
  List<LastPlayedEntity> lastPlayed = [];
  List<MostPlayedEntity> mostPlayed = [];
  PlaylistEntity? energizing;
  PlaylistEntity? relaxing;
  PlaylistEntity? romance;
  PlaylistEntity? sleep;

  PlaylistState(
  {this.playlists = const [], this.favorites = const [], this.lastPlayed = const [], this.mostPlayed = const [], this.energizing, this.relaxing, this.romance, this.sleep});
}
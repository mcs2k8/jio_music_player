import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../api/client.dart';
import '../managers/player_manager.dart';

class ArtworkWidget extends StatelessWidget {
  AudioModel? song;
  double radius;
  ArtworkWidget(this.song, this.radius, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(song),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ClipOval(
              child: SizedBox.fromSize(
                  size:  Size.fromRadius(radius), // Image radius
                  child: Image.asset('assets/vinyl.png')));
        } else if (snapshot.hasError) {
          return ClipOval(
              child: SizedBox.fromSize(
                  size: Size.fromRadius(radius), // Image radius
                  child: Image.asset('assets/vinyl.png')));
        } else {
          return ClipOval(
              child: SizedBox.fromSize(
                  size: Size.fromRadius(radius), // Image radius
                  child: Image.network(snapshot.data as String)));
        }
      },
    );
  }
}

class SquareArtworkWidget extends StatelessWidget {
  AudioModel? song;
  double radius;
  SquareArtworkWidget(this.song, this.radius, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(song),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ClipRect(
              child: SizedBox.fromSize(
                  size:  Size(radius, radius*1.5), // Image radius
                  child: Image.asset('assets/vinyl.png')));
        } else if (snapshot.hasError) {
          return ClipRect(
              child: SizedBox.fromSize(
                  size: Size(radius, radius*1.5), // Image radius
                  child: Image.asset('assets/vinyl.png')));
        } else {
          return ClipRect(
              child: Flex(direction: Axis.horizontal, children: [Expanded(child: Image.network(snapshot.data as String, fit: BoxFit.cover,))],));
        }
      },
    );
  }
}

Future<String> getImageUrl(AudioModel? song) async {
  if (song == null) throw Error();
  String? imageUrl = await PlayerManager.instance.getLocalImageUrl(song.albumId);
  var img_url = '';
  if (imageUrl == null) {
    Map result =
    await MusicApiClient.qq.search("${song.artist} ${song.title}", 1);
    if (result['result'] != null &&
        (result['result'] as List).isNotEmpty) {
      img_url = result['result'][0]['img_url'];
      await PlayerManager.instance
          .setImageUrl(song.albumId!, img_url);
    }
  } else {
    img_url = imageUrl;
  }
  return img_url;
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'musicbrainz_models.dart';
import 'package:music_player/.local/variables.dart' as localVariables;

class MusicInformationWorker {
  MusicInformationWorker._();

  static final instance = MusicInformationWorker._();

  String root = 'https://musicbrainz.org/ws/2/';
  ValueNotifier<String?> artistPhotoNotifier = ValueNotifier(null);

  Future<void> fetchArtistPhoto(String artistName) async {
    artistPhotoNotifier.value = null;
    http.Response response = await http.get(Uri.parse("${root}artist?query=${artistName}&limit=1"), headers: {
      'User-Agent': 'JioMusicPlayer/1.0.0 (${localVariables.emailAddress})',
      'Accept': 'application/json'
    });
    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      Artist artist = Artist.fromJson(json['artists'][0]);
      //got artist, now get their photo
      response = await http.get(Uri.parse("http://webservice.fanart.tv/v3/music/${artist.id}?api_key=${localVariables.fanartApiKey}"), );
      if (response.statusCode == 200){
        var json = jsonDecode(response.body);
        String? image = json['artistbackground']?[0]?['url'] ?? json['musicbanner']?[0]?['url'] ;
        if (image != null){
          print(image);
          artistPhotoNotifier.value = image;
        }
      }else{
        print("error occurred when fetching image of ${artistName}");
      }
    }
  }
}

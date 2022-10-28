import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:on_audio_query/on_audio_query.dart';
import './provider.dart';

class QQ extends Provider{
  var meta = { 'name': 'QQ', 'platformId': 'qq', 'enName': 'qq' };

  @override
  Future<Map> showPlaylist(offset) async {
    var url = 'https://c.y.qq.com/splcloud/fcgi-bin/fcg_get_diss_by_tag.fcg?picmid=1&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq.json&needNewCode=0&categoryId=10000000&sortId=5&sin=${offset}&ein=${29 + offset}';

    http.Response response = await http.get(Uri.parse(url), headers: {
        'Referer': 'https://y.qq.com/',
    });
    var json = jsonDecode(response.body);
    var playlists = (json['data']['list'] as List).map((item) => {
      'cover_img_url': item['imgurl'],
      'title': item["dissname"],
      'id': 'qqplaylist_${item["dissid"]}',
      'source_url': 'http://y.qq.com/#type=taoge&id=${item["dissid"]}',
    }).toList();
    return { 'result': playlists };
}

  @override
Future<Map> search(var keyword, var page) async {
  var url =
  'http://i.y.qq.com/s.music/fcgi-bin/search_for_qq_cp?g_tk=938407465&uin=0&format=jsonp&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&needNewCode=1&w=${keyword}&zhidaqu=1&catZhida=1&t=0&flag=1&ie=utf-8&sem=1&aggr=0&perpage=20&n=20&p=${page}&remoteplace=txt.mqq.all&_=1459991037831&jsonpCallback=jsonp4';

  http.Response response = await http.post(Uri.parse(url), headers: {
    'Referer': 'https://y.qq.com/',
  });
  var textData = response.body;
  // print("qq response: $textData");
  var text = RegExp(r'(?<=jsonp4\().*(?=\))').stringMatch(textData);
  var json = jsonDecode(text!);
  var tracks = (json['data']['song']['list'] as List).map((e) => qqConvertSong(e)).toList();
  // print(tracks);
  return {
    'result': tracks,
    'total': json['data']['song']['totalnum']
  };
}

  @override
Future<Map> getPlaylist(String playlistId) async {
  var listId = playlistId.split('_').last;
  var targetUrl = 'http://i.y.qq.com/qzone-music/fcg-bin/fcg_ucc_getcdinfo_byids_cp.fcg?type=1&json=1&utf8=1&onlysong=0&jsonpCallback=jsonCallback&nosign=1&disstid=${listId}&g_tk=5381&loginUin=0&hostUin=0&format=jsonp&inCharset=GB2312&outCharset=utf-8&notice=0&platform=yqq&jsonpCallback=jsonCallback&needNewCode=0';

  http.Response response = await http.get(Uri.parse(targetUrl), headers: {
    'Referer': 'https://y.qq.com/',
  });
  var textData = response.body;
  var text = RegExp(r'(?<=jsonCallback\().*(?=\))').stringMatch(textData);
  var json = jsonDecode(text!);
  var info = {
    'cover_img_url': json["cdlist"][0]["logo"],
    'title': json["cdlist"][0]["dissname"],
    'id': 'qqplaylist_${listId}',
    'source_url': 'http://y.qq.com/#type=taoge&id=${listId}',
  };
  var tracks = (json['cdlist'][0]['songlist'] as List).map((e) => qqConvertSong(e)).toList();
  return {
    'tracks': tracks,
    'info': info
  };
}

  @override
Future<String> bootstrapTrack(String trackId) async {
  var songId = trackId.replaceAll('qqtrack_', '');
  var targetUrl =
  'https://u.y.qq.com/cgi-bin/musicu.fcg?loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq.json&needNewCode=0&data=%7B%22req_0%22%3A%7B%22module%22%3A%22vkey.GetVkeyServer%22%2C%22method%22%3A%22CgiGetVkey%22%2C%22param%22%3A%7B%22guid%22%3A%2210000%22%2C%22songmid%22%3A%5B%22${songId}%22%5D%2C%22songtype%22%3A%5B0%5D%2C%22uin%22%3A%220%22%2C%22loginflag%22%3A1%2C%22platform%22%3A%2220%22%7D%7D%2C%22comm%22%3A%7B%22uin%22%3A0%2C%22format%22%3A%22json%22%2C%22ct%22%3A20%2C%22cv%22%3A0%7D%7D';

  http.Response response = await http.get(Uri.parse(targetUrl), headers: {
    'Referer': 'https://y.qq.com/',
    'User-Agent': 'Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; BLA-AL00 Build/HUAWEIBLA-AL00) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/8.9 Mobile Safari/537.36',
  });
  var json = jsonDecode(Utf8Codec().decode(response.bodyBytes));
  if (json['req_0']['data']['midurlinfo'][0]['purl'] == ''){
    return '';
  }
  var url = json['req_0']['data']['sip'][0] + json['req_0']['data']['midurlinfo'][0]['purl'];
  return url;
}


  @override
  Map parseUrl(url) {
    var result = null;
    url = url.replaceAll('/ryqq/', '/yqq/');
    var match = RegExp('//y.qq.com/n/yqq/playlist/([0-9]+)').allMatches(url).toList();

    if (match.isNotEmpty) {
    var playlistId = match[0].group(1);

    result = {
    'type': 'playlist',
    'id': 'qqplaylist_$playlistId',
    };
    }
    match = RegExp('//y.qq.com/n/yqq/playsquare/([0-9]+)').allMatches(url).toList();
    if (match.isNotEmpty) {
    var playlistId = match[1];

    result = {
    'type': 'playlist',
    'id': 'qqplaylist_$playlistId',
    };
    }
    match = RegExp('//y.qq.com/n/m/detail/taoge/index.html?id=([0-9]+)').allMatches(url).toList();
    if (match.isNotEmpty) {
    var playlistId = match[1];

    result = {
    'type': 'playlist',
    'id': 'qqplaylist_$playlistId',
    };
    }

    return result;
  }

  String htmlDecode(String s){
    return s;
  }

  String qqGetImageUrl(String qqimgid, String imgType) {
    if (qqimgid == null || qqimgid.isEmpty) {
      return '';
    }
    var category = '';

    if (imgType == 'artist') {
      category = 'mid_singer_300';
    }
    if (imgType == 'album') {
      category = 'mid_album_300';
    }
    //print("$category $qqimgid");
    var s = '';
    if (qqimgid.length > 1){
      s = [
        category,
        qqimgid[qqimgid.length - 2],
        qqimgid[qqimgid.length - 1],
        qqimgid,
      ].join('/');
    }
    var url = 'http://imgcache.qq.com/music/photo/$s.jpg';

    return url;
  }

  bool qqIsPlayable(song) {
    String switchnum = (song['switch'] as int).toRadixString(2);
    var switchFlag = switchnum.split('');

    switchFlag.removeLast();
    switchFlag = switchFlag.reversed.toList();

    // flag switch table meaning:
    // ["play_lq", "play_hq", "play_sq", "down_lq", "down_hq", "down_sq", "soso",
    //  "fav", "share", "bgm", "ring", "sing", "radio", "try", "give"]
    var playFlag = switchFlag.isNotEmpty ? switchFlag[0] : '';

    return playFlag == '1';
  }

  Map qqConvertSong(song) {
    var d = {
      'id': 'qqtrack_${song["songmid"]}',
      'title': htmlDecode(song["songname"]),
      'artist': htmlDecode(song["singer"][0]["name"]),
      'artist_id': 'qqartist_${song["singer"][0]["mid"]}',
      'album': htmlDecode(song["albumname"]),
      'album_id': 'qqalbum_${song["albummid"]}',
      'img_url': qqGetImageUrl(song["albummid"], 'album'),
      'source': 'qq',
      'source_url': 'http://y.qq.com/#type=song&mid=${song["songmid"]}&tpl=yqq_song_detail',
      'url': 'qqtrack_${song["songmid"]}',
      'disabled': !qqIsPlayable(song),
    };

    return d;
  }

  AudioModel toAudioModel(Map song) {
    return AudioModel({
      '_id': 70080080 + Random().nextInt(80080) + int.parse((song['id'] as String).replaceAll(RegExp(r'[^0-9]'), '')),
      "audio_id": int.parse((song['id'] as String).replaceAll(RegExp(r'[^0-9]'), '')),
      "_data": song['source_url'],
      "_uri": song['source_url'],
      "_display_name": song['title'],
      "_display_name_wo_ext": song['title'],
      "_size": 0,
      "album": song['album'],
      "album_id": int.parse((song['album_id'] as String).replaceAll(RegExp(r'[^0-9]'), '')),
      "artist": song['artist'],
      "artist_id": int.parse((song['artist_id'] as String).replaceAll(RegExp(r'[^0-9]'), '')),
      "genre": '',
      "genre_id": 0,
      "bookmark": 0,
      "composer": '',
      "date_added": 0,
      "date_modified": 0,
      "duration": 0,
      "track": 0,
      "title": song['title'],
      "file_extension": "m4a",
      "is_alarm": false,
      "is_audiobook": false,
      "is_music": true,
      "is_notification": false,
      "is_podcast": false,
      "is_ringtone": false,
      'image_url': song['img_url'],
      'track_id': song['id']
    });
  }
}
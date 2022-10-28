import 'dart:convert';
import 'package:http/http.dart' as http;
import './provider.dart';

class Netease extends Provider{

  @override
  Future<String> bootstrapTrack(String trackId) async {
    var url = 'http://music.163.com/weapi/song/enhance/player/url/v1?csrf_token=';

    var songId = trackId.replaceAll('netrack_', '');

    var data = {
      'ids': [songId],
      'level': 'standard',
      'encodeType': 'aac',
      'csrf_token': '',
    };

    var json = await requestAPI(url, data);
    String songUrl = json['data'][0]['url'] ?? '';
    return songUrl;
  }

  @override
  Future<Map> getPlaylist(String playlistId) {
    // TODO: implement getPlaylist
    throw UnimplementedError();
  }

  @override
  Map parseUrl(url) {
    // TODO: implement parseUrl
    throw UnimplementedError();
  }

  @override
  Future<Map> search(keyword, page) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<Map> showPlaylist(offset) {
    // TODO: implement showPlaylist
    throw UnimplementedError();
  }

  Future<Map> requestAPI(url, data) async {
    //TODO: here, queryString is a library that stringifies objects into query strings: makes them look like var=value&var2=value2
    //TODO: weapi is a file that encrypts the data given to it... Have to convert it into dart code first...
    http.Response response = await http.post(Uri.parse(url), headers: {
      'referer': 'https://music.163.com/',
      'content-type': 'application/x-www-form-urlencoded',
      'user-agent':
      'Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; BLA-AL00 Build/HUAWEIBLA-AL00) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/8.9 Mobile Safari/537.36',
    },
        // body: queryString.stringify(weapi(data)
        );
    return jsonDecode(response.body);
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import './provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/kugou_utils.dart';

class Kugou extends Provider {
  @override
  Future<String> bootstrapTrack(String trackId) async {
    var song_id = trackId.substring('kgtrack_'.length);
    var target_url = 'http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=${song_id}';
    http.Response response = await http.get(Uri.parse(target_url), headers: {
      'referer': 'http://m.kugou.com',
      'content-type': 'application/x-www-form-urlencoded',
    });
    return jsonDecode(response.body)['url'];
  }

  @override
  Future<Map> getPlaylist(String playlistId) async {
    var listId = playlistId.split('_')[0];
    var d = playlistId
        .split('_')
        .last;
    switch (listId) {
      case 'kgplaylist':
        return kg_get_playlist(d);
      case 'kgalbum':
        return kg_album(d);
      case 'kgartist':
        return kg_artist(d);
      default:
        return {
          'info': {},
          'tracks': []
        };
    }
  }

  @override
  Map parseUrl(url) {
    Map result = {};

    var r = RegExp(r'/\/\/music\.163\.com\/playlist\/([0-9]+)/g').firstMatch(
        url);

    if (r != null) {
      return {
        'type': 'playlist',
        'id': 'neplaylist_${r[1]}',
      };
    }

    if (
    url.contains('//music.163.com/#/m/playlist') ||
    url.contains('//music.163.com/#/playlist') ||
    url.contains('//music.163.com/playlist')||
    url.contains('//music.163.com/#/my/m/music/playlist')) {
    var parsed = Uri.parse(url);

    result = {
      'type': 'playlist',
      'id': 'neplaylist_${parsed.queryParameters['id']}',
    };
    }

    return
    result;
  }

  @override
  Future<Map> search(keyword, page) async {
    var target_url = 'http://songsearch.kugou.com/song_search_v2?keyword=${keyword}&page=${page}';
    var data = await requestAPI(target_url, {});
    var tracks =(data['data']['lists'] as List);
    var result = [];
    for (var i in tracks){
      Map track = await kg_render_search_result_item(i);
      result.add(track);
    }
    return {
      'result': result,
      'total': data['total']
    };
  }

  @override
  Future<Map> showPlaylist(offset) async {
    var url = 'http://m.kugou.com/plist/index?json=true&page=${offset}';
    http.Response response = await http.get(Uri.parse(url));
    var playlists = (jsonDecode(response.body)['plist']['list']['info'] as List).map((item) =>
    {
      'cover_img_url': item["imgurl"] != null ? (item["imgurl"] as String).replaceAll('{size}', '400') : '',
      'title': item["specialname"],
      'id': 'kgplaylist_${item["specialid"]}',
      'source_url': 'http://www.kugou.com/yy/special/single/{size}.html'.replaceAll('{size}', (item["specialid"] as int).toString()),
    }).toList();

    return {
      'result': playlists,
      'hasNextPage': jsonDecode(response.body)['plist']['list']['has_next']
    };
  }

  Future<Map> requestAPI(url, Map data) async {
    var token = await getToken();

    http.Response response = await http.get(Uri.parse(url), headers: {
      'referer': 'http://m.kugou.com',
      'content-type': 'application/x-www-form-urlencoded',
      'user-agent':
      'Mozilla/5.0 (Linux; U; Android 8.1.0; zh-cn; BLA-AL00 Build/HUAWEIBLA-AL00) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/8.9 Mobile Safari/537.36',
      'cookie': 'kg_dfid=${token["dfid"]};kg_dfid_collect=${token["collect"]};kg_mid=${token["mid"]}',
    }, );
    //body: data.isNotEmpty ? jsonEncode(data) : ''
    var json = jsonDecode(response.body);
    return json;
  }

  Future<Map> getToken() async {
    var kgKey = 'kg_token';
    var tokenString = await MyStorage.getData(kgKey);
    if (tokenString != null) {
      return jsonDecode(tokenString);
    }
    var t = await getTokenUrl();

    http.Response response = await http.post(Uri.parse(t['url']),
        body: 'eyJhcHBDb2RlTmFtZSI6Ik1vemlsbGEiLCJhcHBOYW1lIjoiTmV0c2NhcGUiLCJhcHBWZXJzaW9uIjoiNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83NS4wLjM3NzAuMTAwIFNhZmFyaS81MzcuMzYiLCJjb25uZWN0aW9uIjoib3RoZXIiLCJkb05vdFRyYWNrIjoiIiwiaGFyZHdhcmVDb25jdXJyZW5jeSI6OCwibGFuZ3VhZ2UiOiJlbiIsImxhbmd1YWdlcyI6ImVuLHpoLUNOLHpoIiwibWF4VG91Y2hQb2ludHMiOjAsIm1pbWVUeXBlcyI6ImFwcGxpY2F0aW9uL21zZXhjZWwsYXBwbGljYXRpb24vbXNwb3dlcnBvaW50LGFwcGxpY2F0aW9uL21zd29yZCxhcHBsaWNhdGlvbi9tc3dvcmQtdGVtcGxhdGUsYXBwbGljYXRpb24vcGRmLGFwcGxpY2F0aW9uL3ZuZC5jZXMtcXVpY2twb2ludCxhcHBsaWNhdGlvbi92bmQuY2VzLXF1aWNrc2hlZXQsYXBwbGljYXRpb24vdm5kLmNlcy1xdWlja3dvcmQsYXBwbGljYXRpb24vdm5kLm1zLWV4Y2VsLGFwcGxpY2F0aW9uL3ZuZC5tcy1leGNlbC5zaGVldC5tYWNyb0VuYWJsZWQuMTIsYXBwbGljYXRpb24vdm5kLm1zLWV4Y2VsLnNoZWV0Lm1hY3JvZW5hYmxlZC4xMixhcHBsaWNhdGlvbi92bmQubXMtcG93ZXJwb2ludCxhcHBsaWNhdGlvbi92bmQubXMtcG93ZXJwb2ludC5wcmVzZW50YXRpb24ubWFjcm9FbmFibGVkLjEyLGFwcGxpY2F0aW9uL3ZuZC5tcy1wb3dlcnBvaW50LnByZXNlbnRhdGlvbi5tYWNyb2VuYWJsZWQuMTIsYXBwbGljYXRpb24vdm5kLm1zLXdvcmQsYXBwbGljYXRpb24vdm5kLm1zLXdvcmQuZG9jdW1lbnQuMTIsYXBwbGljYXRpb24vdm5kLm1zLXdvcmQuZG9jdW1lbnQubWFjcm9FbmFibGVkLjEyLGFwcGxpY2F0aW9uL3ZuZC5tcy13b3JkLmRvY3VtZW50Lm1hY3JvZW5hYmxlZC4xMixhcHBsaWNhdGlvbi92bmQubXN3b3JkLGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC5wcmVzZW50YXRpb25tbC5wcmVzZW50YXRpb24sYXBwbGljYXRpb24vdm5kLm9wZW54bWxmb3JtYXRzLW9mZmljZWRvY3VtZW50LnByZXNlbnRhdGlvbm1sLnRlbXBsYXRlLGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC5zcHJlYWRzaGVldG1sLnNoZWV0LGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC5zcHJlYWRzaGVldG1sLnRlbXBsYXRlLGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC53b3JkcHJvY2Vzc2luZ21sLmRvY3VtZW50LGFwcGxpY2F0aW9uL3ZuZC5vcGVueG1sZm9ybWF0cy1vZmZpY2Vkb2N1bWVudC53b3JkcHJvY2Vzc2luZ21sLnRlbXBsYXRlLGFwcGxpY2F0aW9uL3ZuZC5wcmVzZW50YXRpb24tb3BlbnhtbCxhcHBsaWNhdGlvbi92bmQucHJlc2VudGF0aW9uLW9wZW54bWxtLGFwcGxpY2F0aW9uL3ZuZC5zcHJlYWRzaGVldC1vcGVueG1sLGFwcGxpY2F0aW9uL3ZuZC53b3JkcHJvY2Vzc2luZy1vcGVueG1sLGFwcGxpY2F0aW9uL3gtZ29vZ2xlLWNocm9tZS1wZGYsYXBwbGljYXRpb24veC1uYWNsLGFwcGxpY2F0aW9uL3gtcG5hY2wsdGV4dC9jc3YiLCJwbGF0Zm9ybSI6IldpbjMyIiwicGx1Z2lucyI6IkNocm9tZSBQREYgUGx1Z2luLENocm9tZSBQREYgVmlld2VyLEdvb2dsZeaWh+aho+OAgeihqOagvOWPiuW5u+eBr+eJh+eahE9mZmljZee8lui+keaJqeWxleeoi+W6jyxOYXRpdmUgQ2xpZW50IiwidXNlckFnZW50IjoiTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzc1LjAuMzc3MC4xMDAgU2FmYXJpLzUzNy4zNiIsImNvbG9yRGVwdGgiOjI0LCJwaXhlbERlcHRoIjoyNCwic2NyZWVuUmVzb2x1dGlvbiI6IjE5MjB4MTA4MCIsInRpbWV6b25lT2Zmc2V0IjotNDgwLCJzZXNzaW9uU3RvcmFnZSI6dHJ1ZSwibG9jYWxTdG9yYWdlIjp0cnVlLCJpbmRleGVkREIiOnRydWUsImNvb2tpZSI6dHJ1ZSwiYWRCbG9jayI6dHJ1ZSwiZGV2aWNlUGl4ZWxSYXRpbyI6MSwiaGFzTGllZE9zIjpmYWxzZSwiaGFzTGllZExhbmd1YWdlcyI6ZmFsc2UsImhhc0xpZWRSZXNvbHV0aW9uIjpmYWxzZSwiaGFzTGllZEJyb3dzZXIiOmZhbHNlLCJ3ZWJnbFJlbmRlcmVyIjoiQU5HTEUgKEFNRCBSYWRlb24oVE0pIFJYIFZlZ2EgMTEgR3JhcGhpY3MgRGlyZWN0M0QxMSB2c181XzAgcHNfNV8wKSIsIndlYmdsVmVuZG9yIjoiR29vZ2xlIEluYy4iLCJjYW52YXMiOiJhMjBiNDg4N2U5ZTI1Nzg4MDlhMDE0Y2VlN2YzNjgwZiIsImZvbnRzIjoiQXJpYWwsQXJpYWwgQmxhY2ssQXJpYWwgTmFycm93LEJvb2sgQW50aXF1YSxCb29rbWFuIE9sZCBTdHlsZSxDYWxpYnJpLENhbWJyaWEsQ2FtYnJpYSBNYXRoLENlbnR1cnksQ2VudHVyeSBHb3RoaWMsQ2VudHVyeSBTY2hvb2xib29rLENvbWljIFNhbnMgTVMsQ29uc29sYXMsQ291cmllcixDb3VyaWVyIE5ldyxHZW9yZ2lhLEhlbHZldGljYSxJbXBhY3QsTHVjaWRhIEJyaWdodCxMdWNpZGEgQ2FsbGlncmFwaHksTHVjaWRhIENvbnNvbGUsTHVjaWRhIEZheCxMdWNpZGEgSGFuZHdyaXRpbmcsTHVjaWRhIFNhbnMsTHVjaWRhIFNhbnMgVHlwZXdyaXRlcixMdWNpZGEgU2FucyBVbmljb2RlLE1pY3Jvc29mdCBTYW5zIFNlcmlmLE1vbm90eXBlIENvcnNpdmEsTVMgR290aGljLE1TIFBHb3RoaWMsTVMgUmVmZXJlbmNlIFNhbnMgU2VyaWYsTVMgU2FucyBTZXJpZixNUyBTZXJpZixQYWxhdGlubyBMaW5vdHlwZSxTZWdvZSBQcmludCxTZWdvZSBTY3JpcHQsU2Vnb2UgVUksU2Vnb2UgVUkgTGlnaHQsU2Vnb2UgVUkgU2VtaWJvbGQsU2Vnb2UgVUkgU3ltYm9sLFRhaG9tYSxUaW1lcyxUaW1lcyBOZXcgUm9tYW4sVHJlYnVjaGV0IE1TLFZlcmRhbmEsV2luZ2RpbmdzLFdpbmdkaW5ncyAyLFdpbmdkaW5ncyAzLEFnZW5jeSBGQixBbGdlcmlhbixCYXNrZXJ2aWxsZSBPbGQgRmFjZSxCYXVoYXVzIDkzLEJlbGwgTVQsQmVybGluIFNhbnMgRkIsQmVybmFyZCBNVCBDb25kZW5zZWQsQmxhY2thZGRlciBJVEMsQm9kb25pIE1ULEJvZG9uaSBNVCBCbGFjayxCb2RvbmkgTVQgQ29uZGVuc2VkLEJvb2tzaGVsZiBTeW1ib2wgNyxCcmFkbGV5IEhhbmQgSVRDLEJyb2Fkd2F5LEJydXNoIFNjcmlwdCBNVCxDYWxpZm9ybmlhbiBGQixDYWxpc3RvIE1ULENhbmRhcmEsQ2FzdGVsbGFyLENlbnRhdXIsQ2hpbGxlcixDb2xvbm5hIE1ULENvbnN0YW50aWEsQ29vcGVyIEJsYWNrLENvcHBlcnBsYXRlIEdvdGhpYyxDb3BwZXJwbGF0ZSBHb3RoaWMgTGlnaHQsQ29yYmVsLEN1cmx6IE1ULEVicmltYSxFZHdhcmRpYW4gU2NyaXB0IElUQyxFbGVwaGFudCxFbmdyYXZlcnMgTVQsRmFuZ1NvbmcsRmVsaXggVGl0bGluZyxGb290bGlnaHQgTVQgTGlnaHQsRm9ydGUsRnJlZXN0eWxlIFNjcmlwdCxGcmVuY2ggU2NyaXB0IE1ULEdhYnJpb2xhLEdpZ2ksR2lsbCBTYW5zIE1ULEdpbGwgU2FucyBNVCBDb25kZW5zZWQsR291ZHkgT2xkIFN0eWxlLEdvdWR5IFN0b3V0LEhhZXR0ZW5zY2h3ZWlsZXIsSGFycmluZ3RvbixIaWdoIFRvd2VyIFRleHQsSW1wcmludCBNVCBTaGFkb3csSW5mb3JtYWwgUm9tYW4sSm9rZXJtYW4sSnVpY2UgSVRDLEthaVRpLEtyaXN0ZW4gSVRDLEt1bnN0bGVyIFNjcmlwdCxNYWduZXRvLE1haWFuZHJhIEdELE1hbGd1biBHb3RoaWMsTWFybGV0dCxNYXR1cmEgTVQgU2NyaXB0IENhcGl0YWxzLE1pY3Jvc29mdCBIaW1hbGF5YSxNaWNyb3NvZnQgSmhlbmdIZWksTWljcm9zb2Z0IE5ldyBUYWkgTHVlLE1pY3Jvc29mdCBQaGFnc1BhLE1pY3Jvc29mdCBUYWkgTGUsTWljcm9zb2Z0IFlhSGVpLE1pY3Jvc29mdCBZaSBCYWl0aSxNaW5nTGlVX0hLU0NTLUV4dEIsTWluZ0xpVS1FeHRCLE1pc3RyYWwsTW9kZXJuIE5vLiAyMCxNb25nb2xpYW4gQmFpdGksTVMgUmVmZXJlbmNlIFNwZWNpYWx0eSxNUyBVSSBHb3RoaWMsTVYgQm9saSxOaWFnYXJhIEVuZ3JhdmVkLE5pYWdhcmEgU29saWQsTlNpbVN1bixPbGQgRW5nbGlzaCBUZXh0IE1ULE9ueXgsUGFsYWNlIFNjcmlwdCBNVCxQYXB5cnVzLFBhcmNobWVudCxQZXJwZXR1YSxQZXJwZXR1YSBUaXRsaW5nIE1ULFBsYXliaWxsLFBNaW5nTGlVLUV4dEIsUG9vciBSaWNoYXJkLFByaXN0aW5hLFJhdmllLFJvY2t3ZWxsLFJvY2t3ZWxsIENvbmRlbnNlZCxTaG93Y2FyZCBHb3RoaWMsU2ltSGVpLFNpbVN1bixTaW1TdW4tRXh0QixTbmFwIElUQyxTdGVuY2lsLFN5bGZhZW4sVGVtcHVzIFNhbnMgSVRDLFR3IENlbiBNVCxUdyBDZW4gTVQgQ29uZGVuc2VkLFZpbmVyIEhhbmQgSVRDLFZpdmFsZGksVmxhZGltaXIgU2NyaXB0LFdpZGUgTGF0aW4iLCJkdCI6IjIwMjAtMDgtMDMiLCJ0aW1lIjoiMjAyMC0wOC0wMyAxNzo1NTo0MyIsInVzZXJpZCI6IiIsIm1pZCI6ImMzOGE1MjA1Y2JhZTdiMWIwNDNmMDcyYTUxYzJjODkyIiwidXVpZCI6ImUwZDdmNDdlODdkZmFjOGM3ODU5MGIwYmI0NjU2MjUyIiwiYXBwaWQiOiIxMDE0Iiwid2ViZHJpdmVyIjpmYWxzZSwiY2FsbFBoYW50b20iOmZhbHNlLCJ0ZW1wS2dNaWQiOiIiLCJyZWZlcnJlciI6IiIsInNvdXJjZSI6Imh0dHBzOi8vd3d3Lmt1Z291LmNvbS8iLCJjbGllbnRBcHBpZCI6IiIsImNsaWVudHZlciI6IiIsImNsaWVudE1pZCI6IiIsImNsaWVudERmaWQiOiIiLCJjbGllbnRVc2VySWQiOiIiLCJhdWRpb0tleSI6IjEyNC4wNDM0NDc0NjUzNzM5In0=');
    var jsonResponse = jsonDecode(response.body);
    var dfid = jsonResponse['dfid'];
    var token = {'collect': t['collect'], 'dfid': dfid, 'mid': t['mid']};
    await MyStorage.setData(kgKey, jsonEncode(token));
    return token;
  }

  Future<Map> kg_get_playlist(listId) async {
    var target_url = 'http://m.kugou.com/plist/list/${listId}?json=true';
    http.Response response = await http.get(Uri.parse(target_url));
    var json = jsonDecode(response.body);
    var info = {
      'cover_img_url': json['info']['list']['imgurl']
          ? (json['info']['list']['imgurl'] as String).replaceAll(
          '{size}', '400')
          : '',
      'title': json["info"]['list']['specialname'],
      'id': 'kgplaylist_${json["info"]["list"]["specialid"]}',
      'source_url': 'http://www.kugou.com/yy/special/single/{size}.html'
          .replaceAll('{size}', json['info']['list']['specialid'],)
    };
    var tracks = (json['list']['list']['info'] as List).map((
        e) async => await kg_render_playlist_result_item(e));
    return {
      'info': info,
      'tracks': tracks
    };
  }

  Future<Map?> kg_render_playlist_result_item(item) async {
    var target_url = 'http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=${item["hash"]}';

    var track = {
      'id': 'kgtrack_${item["hash"]}',
      'title': '',
      'artist': '',
      'artist_id': '',
      'album': '',
      'album_id': 'kgalbum_${item["album_id"]}',
      'source': 'kugou',
      'source_url': 'http://www.kugou.com/song/#hash=${item["hash"]}&album_id=${item["album_id"]}',
      'img_url': '',
      'url': 'xmtrack_${item["hash"]}',
      'lyric_url': item["hash"],
    };
    // Fix song info
    http.Response response = await http.get(
        Uri.parse(target_url), headers: {'referer': 'http://www.kugou.com/'});
    var json = jsonDecode(response.body);
    if (json['errorCode'] != 1002) {
      track['title'] = json['songName'];
      track["artist"] = json["singerId"] == 0 ? 'Unknown' : json["singerName"];
      track["artist_id"] = 'kgartist_${json["singerId"]}';
      if (json["imgUrl"] != null) {
        track["img_url"] =
            (json["imgUrl"] as String).replaceAll('{size}', '400');
      } else {
        // track['img_url'] = data.imgUrl.replace('{size}', '400');
      }
    }
    target_url =
    'http://mobilecdnbj.kugou.com/api/v3/album/info?albumid=${item["album_id"]}';
    response = await http.get(Uri.parse(target_url));
    json = jsonDecode(response.body);
    var res_data = json['data']['res_data'];
    if (res_data['errorCode'] != 1002) {
      if (res_data['status'] != null && res_data['data'] != null) {
        track['album'] = res_data['data']['albumname'];
      } else {
        track["album"] = '';
      }
    }
    return track;
  }

  Future<Map> kg_album(listId) async {
    // eslint-disable-line no-unused-vars
    var target_url = 'http://mobilecdnbj.kugou.com/api/v3/album/info?albumid=${listId}';
    http.Response response = await http.get(Uri.parse(target_url));
    var data = jsonDecode(response.body);
    var info = {
      'cover_img_url': data.data.imgurl.replace('{size}', '400'),
      'title': data.data.albumname,
      'id': 'kgalbum_${data["albumid"]}',
      'source_url': 'http://www.kugou.com/album/${data['albumid']}.html',
    };
    target_url =
    'http://mobilecdnbj.kugou.com/api/v3/album/song?albumid=${listId}&page=1&pagesize=-1';
    response = await http.get(Uri.parse(target_url));
    data = jsonDecode(response.body);
    var tracks = (data['data']['info'] as List).map((
        e) async => await kg_render_album_result_item(e, info, listId));
    return {
      'info': info,
      'tracks': tracks
    };
  }

  Future<Map> kg_render_album_result_item(item, info, album_id) async {
    var track = {
      'id': 'kgtrack_${item["hash"]}',
      'title': '',
      'artist': '',
      'artist_id': '',
      'album': info['title'],
      'album_id': 'kgalbum_${album_id}',
      'source': 'kugou',
      'source_url': 'http://www.kugou.com/song/#hash=${item['hash']}&album_id=${album_id}',
      'img_url': '',
      'url': 'xmtrack_${item['hash']}',
      'lyric_url': item['hash'],
    };
    // Fix other data
    var target_url = 'http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=${item["hash"]}';
    http.Response response = await http.get(Uri.parse(target_url));
    var data = jsonDecode(response.body);

    track['title'] = data['songName'];
    track['artist'] = data['singerId'] == 0 ? 'Unknown' : data['singerName'];
    track['artist_id'] = 'kgartist_${data['singerId']}';
    track['img_url'] = (data['imgUrl'] as String).replaceAll('{size}', '400');

    return track;
  }

  Future<Map> kg_artist(listId) async {
    var target_url = 'http://mobilecdnbj.kugou.com/api/v3/singer/info?singerid=${listId}';
    http.Response response = await http.get(Uri.parse(target_url));
    var data = jsonDecode(response.body);
    var info = {
      'cover_img_url': (data['data']['imgurl'] as String).replaceAll(
          '{size}', '400'),
      'title': data['data']['singername'],
      'id': 'kgartist_${listId}',
      'source_url': 'http://www.kugou.com/singer/{id}.html'.replaceAll(
        '{id}',
        listId,
      ),
    };
    target_url =
    'http://mobilecdnbj.kugou.com/api/v3/singer/song?singerid=${listId}&page=1&pagesize=30';
    response = await http.get(Uri.parse(target_url));
    var tracks = (jsonDecode(response.body)['data']['info'] as List).map((
        e) async => await kg_render_artist_result_item(e, info)).toList();
    return {
      'info': info,
      'tracks': tracks
    };
  }

  Future<Map> kg_render_artist_result_item(item, info) async {
    var track = {
      'id': 'kgtrack_${item["hash"]}',
      'title': '',
      'artist': '',
      'artist_id': info['id'],
      'album': '',
      'album_id': 'kgalbum_${item["album_id"]}',
      'source': 'kugou',
      'source_url': 'http://www.kugou.com/song/#hash=${item["hash"]}&album_id=${item["album_id"]}',
      'img_url': '',
      'url': 'kgtrack_${item["hash"]}',
      'lyric_url': item['hash'],
    };
    var one = (item["filename"] as String).split('-');
    track['title'] = one[1].trim();
    track['artist'] = one[0].trim();
    // Fix album name and img
    var target_url = 'http://www.kugou.com/yy/index.php?r=play/getdata&hash=${item["hash"]}';
    http.Response response = await http.get(Uri.parse(
        'http://mobilecdnbj.kugou.com/api/v3/album/info?albumid=${item["album_id"]}'));
    var data = jsonDecode(response.body);
    if (data['status'] != null && data['data'] != null) {
      track['album'] = data['data']['albumname'];
    } else {
      track['album'] = '';
    }

    response = await http.get(Uri.parse(target_url));
    track['img_url'] = jsonDecode(response.body)['data']['img'];
    return track;
  }

  Future<Map> kg_render_search_result_item(item) async {
    var track = kg_convert_song(item);
    // Add singer img
    var url = 'http://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=${track["lyric_url"]}&amp;dfid=3x7tbK1hO4na41SmwR3COpKL&amp;appid=1014&amp;mid=097671c0efd4b8b448626c3399dad797&amp;platid=4&amp;album_id=${item['AlbumID']}&album_audio_id=${item['Audioid']}&_=${DateTime.now().millisecondsSinceEpoch}';
    var data = await requestAPI(url, {});
    track['img_url'] = data['data']['img'] ;
    return track;
  }

  Map kg_convert_song(song) {
    var track = {
    'id': 'kgtrack_${song["FileHash"]}',
    'title': song["SongName"],
    'artist': '',
    'artist_id': '',
    'album': song["AlbumName"],
    'album_id': 'kgalbum_${song["AlbumID"]}',
    'source': 'kugou',
    'source_url': 'http://www.kugou.com/song/#hash=${song["FileHash"]}&album_id=${song["AlbumID"]}',
    'img_url': '',
    'url': 'kgtrack_${song["FileHash"]}',
    'lyric_url': song["FileHash"],
    };
    var singer_id = song["SingerId"];
    var singer_name = song["SingerName"];
    if (song["SingerId"] is List) {
    singer_id = song['SingerId'][0];
    singer_name = singer_name.split('、')[0];
    }
    track["artist"] = singer_name;
    track["artist_id"] = 'kgartist_${singer_id}';
    return track;
  }

}

class MyStorage {
  static Future<void> setData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
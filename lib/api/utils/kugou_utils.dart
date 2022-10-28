import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';


var reg = RegExp('-');

Map getConnectUrl() {
  var e = h(),
      t = 4,
      n = DateTime.now().millisecondsSinceEpoch ~/ 1e3,
      i = S(),
      r = 0,
      a = guid().replaceAll(reg, ''),
      o = '',
      s = '',
      c = {
        'appid': e,
        'platid': t,
        'clientver': 0,
        'clienttime': n,
        'signature': '',
        'mid': i,
        'uuid': a,
        'userid': r,
        'dfid': o,
        'p.token': s,
      };
  c['signature'] = signatureParam(c, e);
  var bodyParam = jsonEncode({'uuid': a});
  var u = base64.encode(utf8.encode(bodyParam));

  // const d = CryptoJS.enc.Utf8.parse(bodyParam);
  // const u = CryptoJS.enc.Base64.stringify(d);
  return {
    'url':
    'https://userservice.kugou.com/risk/v1/r_query_collect?appid=${c["appid"]}&platid=${c["platid"]}&clientver=${c["clientver"]}&clienttime=${c["clienttime"]}&signature=${c["signature"]}&mid=${c["mid"]}&userid=${c["userid"]}&uuid=${c["uuid"]}&dfid=${c["dfid"]}&p.token=${c["p.token"]}',
    'body': u,
};
}

Map getTokenUrl() {
  var n = h(),
      i = 4,
      r = DateTime.now().millisecondsSinceEpoch ~/ 1e3,
      a = S(),
      o = 0,
      c = '';
  //kg_mid a
  //kg_dfid
  //kg_dfid_collect  md5(r)
  var u = {
    'appid': n,
    'platid': i,
    'clientver': 0,
    'clienttime': r,
    'signature': '',
    'mid': a,
    'uuid': guid().replaceAll(reg, ''),
    'userid': o,
    'p.token': c,
  };
  u['signature'] = signatureParam(u, n);
  return {
    'collect': generateMd5(r.toString()),
    'mid': a,
    'url':
    'https://userservice.kugou.com/risk/v1/r_register_dev?appid=${u['appid']}&platid=${u['platid']}&clientver=${u['clientver']}&clienttime=${u['clienttime']}&signature=${u['signature']}&mid=${u['mid']}&userid=${u['userid']}&uuid=${u['uuid']}&p.token=${u['p.token']}'
  };
}

int h() {
  // const e = document.getElementsByTagName('script');
  // if (e && e.length > 0) {
  //   for (var t = 0, n = e.length; t < n; t++) {
  //     var i = e[t].src;
  //     if (i.indexOf('verify/static/js/registerDev1.min.js?appid=') != -1) {
  //       var r = {},
  //         a = (i = i.split('?')[1]).split('&');
  //       for (t = 0; t < a.length; t++) {
  //         r[a[t].split('=')[0]] = unescape(a[t].split('=')[1]);
  //       }
  //       return r.appid;
  //     }
  //   }
  // }
  return 1014;
}

String signatureParam(e, t) {
  var n = [];
  for (var i in (e as Map).keys) {
    if (i != 'signature'){
      n.add(e[i].toString());
    }
  }
  var a = '';
  var r = n;
  r.sort();
  for (var o = 0; o < r.length; o++){
    a += r[o];
  }
  // for (let r = n.sort(), o = 0, s = r.length; o < s; o++) {
  //   a += r[o];
  // }
  return generateMd5(t.toString() + a + t.toString());
}

String S() {
  var e = guid();
  return generateMd5(e);
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String guid() {

  return '${s4() + s4()}-${s4()}-${s4()}-${s4()}-${s4()}${s4()}${s4()}';
}

String s4() {
  return Random().nextInt(20000).toRadixString(16);
}

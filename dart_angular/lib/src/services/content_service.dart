import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'urls.dart';
import '../utility/math.dart';
import 'mock_Json.dart';

class ContentService 
{
  static final _header = {
    'Content-Type': 'application/json',
    };
  final Client _http;

  ContentService(this._http);

  dynamic _extractData(Response resp) {
    dynamic body = json.decode(resp.body);
    print('body $body');
    return body;
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }

  // get data ------------------------------------------------
    Future<List<dynamic>> getArtists() async 
  {
    // int page = randomRange(1, 10);
    // int total = 15;
    // String url = '${getAllSingers}/${total}/${page}';

    // print('getArtists(), url: $url');

    // try {
    //   final response = await _http.get(url, headers: _header);
    //   final artists = _extractData(response);
    //   return artists['list'];
    // } 
    // catch (e) {
    //   print('error for getArtists()');
    //   throw _handleError(e);
    // }
    var items = [];
    for (var i = 0; i < artists_fa.length; i++) {
      var artist = artists_fa[i];
      artist['cover'] = imgs[randomRange(1, imgs.length)];
      items.add(artist);
    }
    return items;
  }

  Future<List<dynamic>> getMedias([String singer='azad cewahêrî']) async 
  {
    // int page = randomRange(1, 10);
    // int total = 15;
    // String url = getAllMedias;
    // Map<String, dynamic> data = {
    //   'total': total,
    //   'page': page,
    //   'singername': singer,
    // };

    // print('getMedias(), url: $url, data: $data');

    // try {
    //   final response = await _http.post(url, body: json.encode(data), headers: _header);
    //   final medias = _extractData(response);
    //   return medias['list'];
    // } 
    // catch (e) {
    //   print('error for getMedias()');
    //   throw _handleError(e);
    // }
    var items = [];
    for (var i = 0; i < media_fa.length; i++) {
      var media = media_fa[i];
      media['cover'] = imgs[randomRange(1, imgs.length)];
      items.add(media);
    }
    return items;
  }

}
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

import '../../class/classes.dart';
import '../urls.dart';
import './requester.dart';

class Archive
{
  Requester _rq;
  Archive(this._rq);

  // methods
  // singer -----------------------------------------------
  Future<Result_Singer> singer_getList(int page, [int total]) async
  {
    int totalItems = 15;
    if(total != null) totalItems = total;

    String url = '${link_archive}/singer/all/${totalItems}/${page}';

    print('singer_getList(), url: $url');

    try {
      final response = await _rq.get(url);
      
      final result = _extractData(response);

      Result_Singer singerList = Result_Singer.fromjson(
        result['pages'], result['current'], result['items']);

      return singerList;
    } 
    catch (e) {
      print('error for singer_getList()');
      throw _handleError(e);
    }
  }

  Future<Singer> singer_get(String name) async
  {
    String url = '${link_archive}/singer';
    dynamic form = {'name': name};
    print('singer_get(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);
      
      Singer singer = Singer.fromjson(result);
      return singer;
    } 
    catch (e) {
      print('error for singer_get()');
      throw _handleError(e);
    }
  }

  // album ------------------------------------------------
  Future<Result_Album> album_getList(String name) async
  {
    String url = '${link_archive}/album/all';
    dynamic form = {'singername': name};
    print('album_getList(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);
      
      Result_Album albumList = Result_Album.fromjson(1, 1, result['albums']);
      return albumList;
    } 
    catch (e) {
      print('error for album_getList()');
      throw _handleError(e);
    }
  }

  Future<Album> album_getById(String id) async
  {
    String url = '${link_archive}/album/id/${id}';
    print('album_getById(), url: $url');

    try {
      final response = await _rq.get(url);
      final result = _extractData(response);
      
      Album album = Album.fromjson(result['album']);
      return album;
    } 
    catch (e) {
      print('error for album_getById()');
      throw _handleError(e);
    }
  }

  Future<Album> album_get(String name, String singer) async
  {
    String url = '${link_archive}/album';
    dynamic form = {'name': name, 'singername': singer};
    print('album_get(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);
      
      Album album = Album.fromjson(result['album']);
      return album;
    } 
    catch (e) {
      print('error for album_get()');
      throw _handleError(e);
    }
  }

  // media ------------------------------------------------
  Future<Result_Media> media_getList(String name, int page, [int total]) async
  {
    int totalItems = 15;
    if(total != null) totalItems = total;

    String url = '${link_archive}/media/all';
    dynamic form = {'singername': name, 'total': totalItems, 'page':page};
    print('media_getList(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);
      
      Result_Media mediaList = Result_Media.fromjson(
        result['pages'], result['current'], result['list']);

      return mediaList;
    } 
    catch (e) {
      print('error for media_getList()');
      throw _handleError(e);
    }
  }

  Future<Media> media_get(String title, String singer) async
  {
    String url = '${link_archive}/media/name';
    dynamic form = {'title': title, 'singername': singer};
    print('media_get(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);

      Media media = Media.fromjson(result['media']);
      return media;
    } 
    catch (e) {
      print('error for media_get()');
      throw _handleError(e);
    }
  }

  Future<Media> media_getById(String id) async
  {
    String url = '${link_archive}/media/id';
    dynamic form = {'id': id};
    print('media_getById(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);

      Media media = Media.fromjson(result['media']);
      return media;
    } 
    catch (e) {
      print('error for media_getById()');
      throw _handleError(e);
    }
  }

  // playlist ---------------------------------------------
  Future<Result_Playlist> playlist_getList() async
  {
    String url = '${link_archive}/playlist/all';
    print('playlist_getList(), url: $url');

    try {
      final response = await _rq.get(url);
      final result = _extractData(response);
      
      Result_Playlist albumList = Result_Playlist.fromjson(1, 1, result['lists']);
      return albumList;
    } 
    catch (e) {
      print('error for playlist_getList()');
      throw _handleError(e);
    }
  }

  Future<Playlist> playlist_get(String name) async
  {
    String url = '${link_archive}/playlist/get';
    dynamic form = {'name': name};
    print('playlist_get(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);

      Playlist playlist = Playlist.fromjson(result['playlist']);
      return playlist;
    } 
    catch (e) {
      print('error for playlist_get()');
      throw _handleError(e);
    }
  }

  Future<Playlist> playlist_getById(String id) async
  {
    String url = '${link_archive}/playlist/id';
    dynamic form = {'id': id};
    print('playlist_getById(), url: $url');

    try {
      final response = await _rq.post(url, body: form);
      final result = _extractData(response);

      Playlist playlist = Playlist.fromjson(result['playlist']);
      return playlist;
    } 
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }
  }

  // stream link
  Future<String> getStreamLink(id)
  {
    print('id $id');
    String url = '${link_archive}/static/96/$id';
    print('getStreamLink(), url: $url');
    return Future.delayed(Duration(milliseconds: 100), () => url);
  }


  // other methods ----------------------------------------
  dynamic _extractData(Response resp) {
    dynamic body = json.decode(resp.body);
    //print('body $body');
    return body;
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
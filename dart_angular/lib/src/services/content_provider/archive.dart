import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

import '../../class/injector.dart';
import '../../services/user_service.dart';

import '../../class/classes.dart';
import '../urls.dart';
import './requester.dart';

class Archive
{
  Requester _rq;

  Archive(this._rq);

  // methods
  // artist -----------------------------------------------
  Future<Result_Artist> artist_getList(int page, {int total=15}) async
  {
    String url = '${link_archive}/singer/all/${total.toString()}/${page.toString()}';

    print('artist_getList(), url: $url');

    try {
      final result = await _rq.get(url);

      Result_Artist artistList = Result_Artist.fromjson(
        result['pages'], result['current'], result['list']);

      return artistList;
    } 
    catch (e) {
      print('error for artist_getList()');
      throw _handleError(e);
    }
  }

  Future<Artist> artist_get(String name) async
  {
    String url = '${link_archive}/singer';
    dynamic form = {'name': name};
    print('artist_get(), url: $url');

    try {
      final result = await _rq.post(url, body: form);
      
      Artist artist = Artist.fromjson(result);
      return artist;
    } 
    catch (e) {
      print('error for artist_get()');
      throw _handleError(e);
    }
  }

  Future<Artist> artist_getById(String id) async
  {
    String url = '${link_archive}/artist/id/$id';
    print('artist_get(), url: $url');

    try {
      final result = await _rq.get(url);
      
      Artist artist = Artist.fromjson(result);
      return artist;
    } 
    catch (e) {
      print('error for artist_get()');
      throw _handleError(e);
    }
  }

  // album ------------------------------------------------
  Future<Result_Album> album_getList(String artist) async
  {
    String url = '${link_archive}/album/all';
    dynamic form = {'artistname': artist};
    print('album_getList(), url: $url');

    try {
      final result = await _rq.post(url, body: form);
      
      Result_Album albumList = Result_Album.fromjson(1, 1, result['albums']);
      return albumList;
    } 
    catch (e) {
      print('error for album_getList()');
      throw _handleError(e);
    }
  }

  Future<Result_Album> album_getAll(int page, {int total=15}) async
  {
    String url = '${link_archive}/album/all/${total.toString()}/${page.toString()}';

    print('album_getAll(), url: $url');

    try {
      final result = await _rq.get(url);

      Result_Album artistList = Result_Album.fromjson(
        result['pages'], result['current'], result['list']);

      return artistList;
    } 
    catch (e) {
      print('error for album_getAll()');
      throw _handleError(e);
    }
  }

  Future<Album> album_getById(String id) async
  {
    String url = '${link_archive}/album/id/${id}';
    print('album_getById(), url: $url');

    try {
      final result = await _rq.get(url);
      
      Album album = Album.fromjson(result['album']);
      return album;
    } 
    catch (e) {
      print('error for album_getById()');
      throw _handleError(e);
    }
  }

  Future<Album> album_get(String name, String artist) async
  {
    String url = '${link_archive}/album';
    dynamic form = {'name': name, 'artistname': artist};
    print('album_get(), url: $url');

    try {
      final result = await _rq.post(url, body: form);
      
      Album album = Album.fromjson(result['album']);
      return album;
    } 
    catch (e) {
      print('error for album_get()');
      throw _handleError(e);
    }
  }

  // media ------------------------------------------------
  Future<Result_Song> media_getList(String name, int page, {int total=15}) async
  {
    String url = '${link_archive}/media/all';
    Map form = {'artistname': name, 'total': total.toString(), 'page':page.toString()};
    print('media_getList(), url: $url');

    try {
      final result = await _rq.post(url, body: form);

      Result_Song mediaList = Result_Song.fromjson(
        result['pages'], result['current'], result['list']);

      return mediaList;
    } 
    catch (e) {
      print('error for media_getList()');
      throw _handleError(e);
    }
  }

  Future<Result_Song> media_getAll(int page, {int total=15}) async
  {
    String url = '${link_archive}/media/all/${total.toString()}/${page.toString()}';

    print('media_getAll(), url: $url');

    try {
      final result = await _rq.get(url);

      Result_Song artistList = Result_Song.fromjson(
        result['pages'], result['current'], result['list']);

      return artistList;
    } 
    catch (e) {
      print('error for media_getAll()');
      throw _handleError(e);
    }
  }

  Future<Song> media_get(String title, String artist) async
  {
    String url = '${link_archive}/media/name';
    dynamic form = {'title': title, 'artistname': artist};
    print('media_get(), url: $url');

    try {
      final result = await _rq.post(url, body: form);

      Song media = Song.fromjson(result['media']);
      return media;
    } 
    catch (e) {
      print('error for media_get()');
      throw _handleError(e);
    }
  }

  Future<Song> media_getById(String id) async
  {
    String url = '${link_archive}/media/id';
    dynamic form = {'id': id};
    print('media_getById(), url: $url');

    try {
      final result = await _rq.post(url, body: form);

      Song media = Song.fromjson(result['media']);
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
      final result = await _rq.post(url, body: {});
      
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
      final result = await _rq.post(url, body: form);

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
      final result = await _rq.post(url, body: form);

      Playlist playlist = Playlist.fromjson(result['playlist']);
      return playlist;
    } 
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }
  }

  // stream link
  Future<String> getStreamLink({String id, String version}) async
  {
    String url = '${link_archive}/static/$version/$id';
    print('getStreamLink(), url: $url');
    final result = await _rq.get(url, directResult: true);
    return result;
    //return Future.delayed(Duration(milliseconds: 100), () => url);
  }

  // favorites
  Future<Playlist> favorites_getList({int total=50, int page=1}) async
  {
    String url = '${link_api_user}/favorites';
    print('favorites_getList(), url: $url');

    UserService userService = Injector.get<UserService>();

    dynamic form = {
      'userid': userService.user.id,
      'type': 'media',
      'total': total.toString(),
      'page': page.toString()
    }; 

    try {
      final result = await _rq.post(url, body: form);
      
      Playlist playlist = Playlist.fromjson(result);
      return playlist;
    } 
    catch (e) {
      print('error for favorites_getList()');
      throw _handleError('$e | $form');
    }
  }

  // other methods ----------------------------------------
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
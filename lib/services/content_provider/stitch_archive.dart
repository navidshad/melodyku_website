/// {@nodoc}
library stitchArchive;

import 'dart:async';
import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/system_schema.dart';

class StitchArchive
{
  StitchService _stitch;

  StitchArchive(this._stitch);

  // methods
  Future<dynamic> getItemByID<T>(String id) async
  {
    //print('getItemByID');
    String collectioName = ResultWithNavigator.getCollection<T>();
    List<DbField> dbFields = ResultWithNavigator.getDbFields<T>();

    Future request = promiseToFuture(
      _stitch.appClient.callFunction('getById', ['media', collectioName, id]));
      
    var result = await _stitch.requestByQueue(request).catchError(_handleError);

    if(result == null)
    {
      _handleError('getItemByID result null | $collectioName $id');
      return null;
    }

    //print('getItemByID begin to convertedToMap');
    Map convertedToMap = convertToMap(result, dbFields);
    T item = ResultWithNavigator.createItemFromDoc<T>(convertedToMap, dontGetSongs: false);

    return item;
  }

  // artist -----------------------------------------------
  Future<ResultWithNavigator<Artist>> artist_getList(int page, {int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Artist>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  // album ------------------------------------------------
  Future<ResultWithNavigator<Album>> album_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    print('album_getListByArtist begin to get');
    Map query = {'artistId': artistId};

    ResultWithNavigator navigator = ResultWithNavigator<Album>(customQuery: query, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<ResultWithNavigator<Album>> album_getList(int page, {int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Album>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  // song ------------------------------------------------
  Future<ResultWithNavigator<Song>> song_getList({int page=1, int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Song>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    Map query = {'artistId': artistId};

    ResultWithNavigator navigator = ResultWithNavigator<Song>(customQuery: query, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByAlbum(String albumId, {int page=1, int total=15}) async
  {
    Map query = {'albumId': albumId};

    ResultWithNavigator navigator = ResultWithNavigator<Song>(customQuery: query, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<Playlist> playlist_getRamdom(String title, {int total=15}) async
  {
    Playlist playlist;

    Map playlistDetail = {
      'title': title, 
      'list': [],
    };

    playlist = Playlist.fromjson(playlistDetail);

    dynamic pipeLine = js.jsify([
        {
          '\$sample': {'size': total}
        }
      ]);

    RemoteMongoCollection coll = _stitch.dbClient.db('media').collection('song');

    Future request = promiseToFuture(coll.aggregate(pipeLine).asArray());
      
    await _stitch.requestByQueue(request)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = convertToMap(doc, SystemSchema.song);
          Song song = Song.fromjson(converted);
          playlist.list.add(song);
        });
      }).catchError(_handleError);

    return playlist;
  }

  // playlist ---------------------------------------------
  Future<ResultWithNavigator> playlist_getList() async
  {
    // String url = '${link_archive}/playlist/all';
    // print('playlist_getList(), url: $url');

    // try {
    //   final result = await _rq.post(url, body: {});
      
    //   Result_Playlist albumList = Result_Playlist.fromjson(1, 1, result['lists']);
    //   return albumList;
    // } 
    // catch (e) {
    //   print('error for playlist_getList()');
    //   throw _handleError(e);
    // }
  }

  // favorites
  Future<Playlist> favorites_getList({int total=50, int page=1}) async
  {
    // String url = '${link_api_user}/favorites';
    // print('favorites_getList(), url: $url');

    // UserService userService = Injector.get<UserService>();

    // dynamic form = {
    //   'userid': userService.user.id,
    //   'type': 'media',
    //   'total': total.toString(),
    //   'page': page.toString()
    // }; 

    // try {
    //   final result = await _rq.post(url, body: form);
      
    //   Playlist playlist = Playlist.fromjson(result);
    //   return playlist;
    // } 
    // catch (e) {
    //   print('error for favorites_getList()');
    //   throw _handleError('$e | $form');
    // }
  }

  // other methods ----------------------------------------
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
import 'dart:async';
import 'dart:html';
import 'package:js/js_util.dart' as js;


import '../../class/injector.dart';

import '../../services/stitch_service.dart';
import '../../class/classes.dart';
import '../../class/archive/system_schema.dart';

class StitchArchive
{
  StitchService _stitch;
  RemoteMongoDatabase _mediaDB;


  StitchArchive(this._stitch)
  {
    _mediaDB = _stitch.dbClient.db('media');
  }

  // methods
  Future<dynamic> getItemByID<T>(String id) async
  {
    //print('getItemByID');
    String collectioName = ResultWithNavigator.getCollection<T>();
    List<DbField> dbFields = ResultWithNavigator.getDbFields<T>();

    RemoteMongoCollection collection = _mediaDB.collection(collectioName);

    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getById', ['media', collectioName, id]))
      .catchError(_handleError);

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

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  // album ------------------------------------------------
  Future<ResultWithNavigator<Album>> album_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    print('album_getListByArtist begin to get');
    Map query = {'artistId': artistId};

    ResultWithNavigator navigator = ResultWithNavigator<Album>(customQuery: query, perPage: total);

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  Future<ResultWithNavigator<Album>> album_getList(int page, {int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Album>(perPage: total);

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  // song ------------------------------------------------
  Future<ResultWithNavigator<Song>> song_getList({int page=1, int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Song>(perPage: total);

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    Map query = {'artistId': artistId};

    ResultWithNavigator navigator = ResultWithNavigator<Song>(customQuery: query, perPage: total);

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByAlbum(String albumId, {int page=1, int total=15}) async
  {
    Map query = {'albumId': albumId};

    ResultWithNavigator navigator = ResultWithNavigator<Song>(customQuery: query, perPage: total);

    await navigator.initialize();
    await navigator.loadNextPage(page);

    return navigator;
  }

  Future<Playlist> playlist_getRamdom(String title, {int total=15}) async
  {
    Playlist playlist;

    Map playlistDetail = {
      'title': title, 
      'list': [],
    };
    int page = randomRange(0, 1100);

    ResultWithNavigator<Song> navigator = await song_getList(page: page);

    playlist = Playlist.fromjson(playlistDetail);
    playlist.list = navigator.list;
    
    // dynamic pipeline = js.jsify([
    //     {
    //       '\$sample': { 'size': total }
    //     }
    //   ]);

    // Map result = await promiseToFuture(
    //     _mediaDB.collection('song').aggregate(pipeline).asArray())
    //     .then((dynamic songs) 
    //     {
          

    //       List list = [];
    //       for(int i=0; i < songs.length; i++)
    //       {
    //         dynamic stitchSong = songs[i];
    //         Map mapSong = convertToMap(stitchSong, SystemSchema.song);
            
    //         //Song sognObject = Song.fromjson(mapSong);
    //         list.add(mapSong);
    //       }

    //       playlistDetail['list'] = list;
    //       return playlistDetail;
    //     })
    //     .catchError((error) {});

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
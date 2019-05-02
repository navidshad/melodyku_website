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
    String collectioName;
    List<DbField> dbFields = [];

    switch(T)
    {
      case Artist: 
        collectioName = 'artist'; 
        dbFields = SystemSchema.artist;
        break;
      case Album: 
        collectioName = 'album'; 
        dbFields = SystemSchema.album;
        break;
      case Song: 
        collectioName = 'song'; 
        dbFields = SystemSchema.song;
        break;
      case Playlist: 
        collectioName = 'playlist'; 
        dbFields = SystemSchema.album;
        break;
    }

    RemoteMongoCollection collection = _mediaDB.collection(collectioName);

    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getById', ['media', collectioName, id]));

    if(result == null)
    {
      _handleError('getItemByID result null | $collectioName $id');
      return null;
    }

    Map convertedToMap = convertToMap(result, dbFields);

    T item;
    switch(T)
    {
      case Artist:    item = Artist.fromjson(convertedToMap) as T; break;
      case Song:      item = Song.fromjson(convertedToMap) as T; break;
      case Album:     item = Album.fromjson(convertedToMap) as T; break;
      case Playlist:  item = Playlist.fromjson(convertedToMap) as T; break;
    }

    return item;
  }

  // artist -----------------------------------------------
  Future<ResultWithNavigator<Artist>> artist_getList(int page, {int total=15, String alphabet}) async
  {
    ResultWithNavigator<Artist> artistListNavigator;

    var result = await _stitch.getAllFromMedia('artist', total, page, alphabet);

    if(result != null) 
      artistListNavigator = ResultWithNavigator.fromMongoStitchResult(result, SystemSchema.artist);
    else _handleError('artist_getList result null');

    return artistListNavigator;
  }

  // album ------------------------------------------------
  Future<ResultWithNavigator<Album>> album_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    ResultWithNavigator<Album> albumListNavigator;

    dynamic query = js.jsify({'artistId': artistId});

    var result = await _stitch.getFromMediaByCustomQuery('album', total, page, query);

    if(result != null) 
      albumListNavigator = ResultWithNavigator.fromMongoStitchResult(result, SystemSchema.album);
    else _handleError('album_getListByArtist result null | $artistId');

    return albumListNavigator;
  }

  Future<ResultWithNavigator<Album>> album_getList(int page, {int total=15, String alphabet}) async
  {
    ResultWithNavigator<Album> albumListNavigator;

    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getAllFromMedia', ['album', total, page, alphabet]));

    if(result != null) 
      albumListNavigator = ResultWithNavigator.fromMongoStitchResult(result, SystemSchema.album);
    else _handleError('album_getList result null');

    return albumListNavigator;
  }

  // song ------------------------------------------------
  Future<ResultWithNavigator<Song>> song_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    ResultWithNavigator<Song> albumListNavigator;

    dynamic query = js.jsify({'artistId': artistId});

    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getFromMediaByCustomQuery', ['song', total, page, query]));

    if(result != null) 
      albumListNavigator = ResultWithNavigator.fromMongoStitchResult(result, SystemSchema.song);

    return albumListNavigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByAlbum(String albumId, {int page=1, int total=15}) async
  {
    ResultWithNavigator<Song> albumListNavigator;

    dynamic query = js.jsify({'albumId': albumId});

    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getFromMediaByCustomQuery', ['song', total, page, query]));

    if(result != null) 
      albumListNavigator = ResultWithNavigator.fromMongoStitchResult(result, SystemSchema.song);

    return albumListNavigator;
  }

  Future<Playlist> playlist_getRamdom(String title, {int total=15}) async
  {
    Playlist playlist;

    dynamic pipeline = js.jsify([
        {
          '\$sample': { 'size': total }
        }
      ]);

    Map result = await promiseToFuture(
        _mediaDB.collection('song').aggregate(pipeline).asArray())
        .then((dynamic songs) 
        {
          Map playlistDetail = {
            'title': title, 
            'list': [],
          };

          List list = [];
          for(int i=0; i < songs.length; i++)
          {
            dynamic stitchSong = songs[i];
            Map mapSong = convertToMap(stitchSong, SystemSchema.song);
            
            //Song sognObject = Song.fromjson(mapSong);
            list.add(mapSong);
          }

          playlistDetail['list'] = list;
          return playlistDetail;
        })
        .catchError((error) {});

    playlist = Playlist.fromjson(result);
    return playlist;
  }

  // playlist ---------------------------------------------
  Future<Result_Playlist> playlist_getList() async
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
/// {@nodoc}
library StitchClonerArchive;

import 'dart:async';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

class MediaSelector
{
  MongoDBService _mongoDBService;

  MediaSelector(this._mongoDBService);

  // methods
  Future<dynamic> getItemByID<T>(String id) async
  {
    // //print('getItemByID');
    String collection = ResultWithNavigator.getCollection<T>();
    List<DbField> dbFields = ResultWithNavigator.getDbFields<T>();

    T item;

    await _mongoDBService.findOne(
      database: 'media',
      collection: collection, query: { '_id': id })
      .then((doc) 
      {
        Map convertedToMap = validateFields(doc, dbFields);
        item = ResultWithNavigator.createItemFromDoc<T>(convertedToMap, dontGetSongs: false);
      })
      .catchError(_handleError);

    return item;
  }

  // artist -----------------------------------------------
  Future<ResultWithNavigator<Artist>> artist_getList(int page, {int total=15}) async
  {
    ResultWithNavigator navigator = ResultWithNavigator<Artist>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<List<Artist>> artist_getRandomList({int total=15, Map<String, dynamic> query}) async
  {
    List<Artist> artists = [];
    List<Map<String, dynamic>> piplines = [];

    if(query != null) 
      piplines.add({ '\$match': query });
      
    piplines.add({'\$sample': {'size': total}});

    await _mongoDBService.aggregate(isLive:true, database:'media', collection: 'artist', piplines: piplines)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = validateFields(doc, SystemSchema.artist);
          Artist artist = Artist.fromjson(converted);
          artists.add(artist);
        });
      }).catchError(_handleError);

    return artists;
  }

  // album ------------------------------------------------
  Future<ResultWithNavigator<Album>> album_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    Map<String, dynamic> query = {'artistId': artistId};

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

  Future<List<Album>> album_getRandomList({int total=15, Map<String, dynamic> query}) async
  {
    List<Album> albums = [];
    List<Map<String, dynamic>> piplines = [];

    if(query != null) 
      piplines.add({ '\$match': query });
      
    piplines.add({'\$sample': {'size': total}});

    await _mongoDBService.aggregate(isLive:true, database:'media', collection: 'album', piplines: piplines)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = validateFields(doc, SystemSchema.album);
          Album album = Album.fromjson(converted);
          albums.add(album);
        });
      }).catchError(_handleError);

    return albums;
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
    Map<String, dynamic> query = {'artistId': artistId};

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

  Future<Playlist> playlist_getRamdom(String title, {int total=15, Map<String, dynamic> query}) async
  {
    Playlist playlist;

    Map playlistDetail = {
      'title': title, 
      'list': [],
    };

    playlist = Playlist.fromjson(playlistDetail);

    List<Map<String, dynamic>> piplines = [];

    if(query != null) 
      piplines.add({ '\$match': query });
      
    piplines.add({'\$sample': {'size': total}});

    await _mongoDBService.aggregate( database: 'media', collection: 'song', piplines: piplines)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = validateFields(doc, SystemSchema.song);
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
  void _handleError(dynamic e) {
    print('Server error; cause: $e'); // for demo purposes only
  }
}
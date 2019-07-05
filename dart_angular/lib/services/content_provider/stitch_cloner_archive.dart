/// {@nodoc}
library StitchClonerArchive;

import 'dart:async';
import 'package:js/js_util.dart' as js;


import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/stitch_cloner/stitch_cloner.dart' as SC;
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

class StitchClonerArchive
{
  StitchClonerService _stitchCloner;

  StitchClonerArchive(this._stitchCloner);

  // methods
  Future<dynamic> getItemByID<T>(String id) async
  {
    // //print('getItemByID');
    String collection = ResultWithNavigator.getCollection<T>();
    List<DbField> dbFields = ResultWithNavigator.getDbFields<T>();

    T item;

    await _stitchCloner.findOne(
      collection: collection, query: { '_id': id })
      .then((doc) 
      {
        Map convertedToMap = convertToMap(js.jsify(doc), dbFields);
        item = ResultWithNavigator.createItemFromDoc<T>(convertedToMap, dontGetSongs: false);
      })
      .catchError(_handleError);

    return item;
  }

  // artist -----------------------------------------------
  Future<SC.ResultWithNavigator<Artist>> artist_getList(int page, {int total=15}) async
  {
    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Artist>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  // album ------------------------------------------------
  Future<SC.ResultWithNavigator<Album>> album_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    print('album_getListByArtist begin to get');
    Map query = {'artistId': artistId};

    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Album>(customQuery: query, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<SC.ResultWithNavigator<Album>> album_getList(int page, {int total=15}) async
  {
    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Album>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  // song ------------------------------------------------
  Future<SC.ResultWithNavigator<Song>> song_getList({int page=1, int total=15}) async
  {
    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Song>(perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<SC.ResultWithNavigator<Song>> song_getListByArtist(String artistId, {int page=1, int total=15}) async
  {
    Map query = {'artistId': artistId};

    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Song>(customQuery: query, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<SC.ResultWithNavigator<Song>> song_getListByAlbum(String albumId, {int page=1, int total=15}) async
  {
    Map query = {'albumId': albumId};

    SC.ResultWithNavigator navigator = SC.ResultWithNavigator<Song>(customQuery: query, perPage: total);

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

    dynamic pipeLine = [
        {
          '\$sample': {'size': total}
        }
      ];

    await _stitchCloner.aggregate(
      collection: 'song', piplines: pipeLine)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = convertToMap(js.jsify(doc), SystemSchema.song);
          Song song = Song.fromjson(converted);
          playlist.list.add(song);
        });
      }).catchError(_handleError);

    return playlist;
  }

  // playlist ---------------------------------------------
  Future<SC.ResultWithNavigator> playlist_getList() async
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
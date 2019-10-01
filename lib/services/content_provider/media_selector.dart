/// {@nodoc}
library StitchClonerArchive;

import 'dart:async';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/mongodb/media_lookup_piplines.dart' as lookupPiplines;

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
      collection: collection, 
      query: { '_id': id },
      options: {
        'populates': [
          {'path': 'artistId'},
          {'path': 'albumId'},
          {
            'path': 'list', 
            'populate': { 'path': 'artistId albumId' }
          } 
        ]
      }
      )
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
    List<TypeCaster> types = [ TypeCaster('ObjectId', '0.\$match.artistId') ];

    ResultWithNavigator navigator = ResultWithNavigator<Album>(
      customQuery: query, perPage: total, types: types);

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
    List<Map> piplines = [];

    if(query != null) 
      piplines.add({ '\$match': query });
      
    piplines.add({'\$sample': {'size': total}});
    piplines.addAll(lookupPiplines.getPiplines('album'));

    await _mongoDBService.aggregate(isLive:true, database:'media', collection: 'album', piplines: piplines)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = validateFields(doc, SystemSchema.album_populteVer);
          Album album = Album.fromPopulatedDoc(converted);
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
    List<TypeCaster> types = [ TypeCaster('ObjectId', '0.\$match.artistId') ];

    ResultWithNavigator navigator = ResultWithNavigator<Song>(
      customQuery: query, perPage: total, types: types);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  Future<ResultWithNavigator<Song>> song_getListByAlbum(String albumId, {int page=1, int total=15}) async
  {
    Map query = {'albumId': albumId};
    List<TypeCaster> types = [ TypeCaster('ObjectId', '0.\$match.albumId') ];

    ResultWithNavigator navigator = ResultWithNavigator<Song>(
      customQuery: query, perPage: total, types: types);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }


  // playlist ---------------------------------------------
  Future<Playlist> playlist_getRamdom(String title, {int total=15, Map<String, dynamic> query}) async
  {
    Playlist playlist;

    Map playlistDetail = validateFields({ '_id':'', 'title': title, 'list': [] }, SystemSchema.playlist);

    playlist = Playlist.fromjson(playlistDetail);

    List<Map> piplines = [];

    if(query != null) 
      piplines.add({ '\$match': query });
      
    piplines.add({'\$sample': {'size': total}});
    piplines.addAll(lookupPiplines.getPiplines('song'));

    await _mongoDBService.aggregate( database: 'media', collection: 'song', piplines: piplines)
      .then((docs) 
      {
        docs.forEach((doc) {
          Map converted = validateFields(doc, SystemSchema.song_populateVer);
          Song song = Song.fromPopulatedDoc(converted);
          playlist.list.add(song);
        });
      }).catchError(_handleError);

    return playlist;
  }

  Future<ResultWithNavigator> playlist_getList({int page=1, int total=15, Map<String, dynamic> query=const{}}) async
  {
    Map queryTemp = { 'forGenerator': false };
    queryTemp.addAll(query);

    ResultWithNavigator navigator = ResultWithNavigator<Playlist>(
      customQuery: queryTemp, perPage: total);

    await navigator.loadNextPage(goto: page);

    return navigator;
  }

  // other methods ----------------------------------------
  void _handleError(dynamic e) {
    print('Server error; cause: $e'); // for demo purposes only
  }
}
import 'dart:async';
import 'package:js/js_util.dart' as js;

import 'album.dart';
import 'artist.dart';
import 'song.dart';
import 'playlist.dart';

import 'package:melodyku/src/services/services.dart';


class ResultWithNavigator<T>
{
  StitchService _stitch;
  RemoteMongoCollection _collection;

  int _pages    = 0;
  int _total    = 0;
  
  int _perPage;
  int _current = 0;

  bool hasMore;

  Map _query;
  Map customQuery;
  String regexPattern;

  List<T> list;

  ResultWithNavigator({this.regexPattern, this.customQuery, int perPage=20})
  {
    _perPage = perPage;

    String coll = getCollection<T>();
    //print('ResultWithNavigator collection $coll');
    _stitch = Injector.get<StitchService>();
    _collection = _stitch.dbClient.db('media').collection(coll);
  }

  static createItemFromDoc<T>(Map doc, {dontGetSongs= true})
  {
    T item;

    if(T == Artist)       item = Artist.fromjson(doc) as T;
    else if(T == Album)   item = Album.fromjson(doc, dontGetSongs: dontGetSongs) as T;
    else if(T == Song)    item = Song.fromjson(doc) as T;

    //print('=== createItemFromDoc T == Song ${(T == Song)}');

    return item;
  }

  static List<DbField> getDbFields<T>()
  {
    List<DbField> list = [];

    if(T == Artist)       list = SystemSchema.artist;
    else if(T == Album)   list = SystemSchema.album;
    else if(T == Song)    list = SystemSchema.song;
    //else if(T == Playlist) list = SystemSchema.artist;

    //print('=== getDbFields ${list.length}');
    return list;
  }

  static String getCollection<T>()
  {
    String collection = '';

    if(T == Artist)       collection = 'artist';
    else if(T == Album)   collection = 'album';
    else if(T == Song)    collection = 'song';
    else if(T == Playlist) collection = 'playlist';

    //print('=== _getCollection $collection');

    return collection;
  }

  List _getMainStages()
  {
    List stages = [];

    if(customQuery != null)
    {
      Map stage = {
        '\$match': customQuery
      };

      stages.add(stage);
    }

    if(regexPattern != null)
    {
      Map stage = {
        '\$match': { 'name': { '\$regex': regexPattern } }
      };

      stages.add(stage);
    }

    return stages;
  }

  Future<void> initialize() async
  {
    // get count ============================
    List countPipeline = _getMainStages();
    countPipeline.add({ "\$count": "count" });

    // _total = await promiseToFuture(_collection.aggregate(js.jsify(countPipeline)).first())
    //   .then((result) {
    //     int value = result != null ? js.getProperty(result, 'count') : 0;
    //     return value;
    //   });
  }

  Future<List<T>> loadNextPage([int goto]) async
  {
    if(goto != null) _current = goto;
    else _current += 1;

    String coll = getCollection<T>();
    dynamic argumants = js.jsify(
        [coll, _perPage, _current, customQuery]
      );
    var result = await promiseToFuture(
      _stitch.appClient.callFunction('getFromMediaByCustomQuery', argumants))
      .catchError(_handleError);

    _pages = js.getProperty(result, 'pages');
    dynamic docs = js.getProperty(result, 'list');

    list = [];
    docs.forEach((doc) 
    {
      Map maped = convertToMap(doc, getDbFields<T>());
      list.add(createItemFromDoc<T>(maped));
    });

    if(_current < _pages) 
      hasMore = true;
    else hasMore = false;

    print('loadNextPage list ${list.length}');
    return list;
  }

  Exception _handleError(dynamic e) {
      print(e); // for demo purposes only
      return Exception('ArtistsExplorerComponent error; cause: $e');
    }
}
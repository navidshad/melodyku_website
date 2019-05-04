import 'dart:async';
import 'package:js/js_util.dart' as js;

import 'album.dart';
import 'artist.dart';
import 'song.dart';
import 'playlist.dart';

import 'package:melodyku/src/services/services.dart';


class ResultWithNavigator<T>
{
  RemoteMongoCollection _collection;

  int _pages    = 0;
  int _total    = 0;
  
  int _perPage;
  int _current;

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
    _collection = Injector.get<StitchService>().dbClient.db('media').collection(coll);
  }

  static createItemFromDoc<T>(Map doc)
  {
    T item;

    if(T == Artist)       item = Artist.fromjson(doc) as T;
    else if(T == Album)   item = Album.fromjson(doc) as T;
    else if(T == Song)    item = Song.fromjson(doc) as T;

    return item;
  }

  static List<DbField> getDbFields<T>()
  {
    List<DbField> list = [];

    if(T == Artist)       list = SystemSchema.artist;
    else if(T == Album)   list = SystemSchema.album;
    else if(T == Song)    list = SystemSchema.song;
    //else if(T == Playlist) list = SystemSchema.artist;

    return list;
  }

  static String getCollection<T>()
  {
    String collection = '';

    if(T == Artist)       collection = 'artist';
    else if(T == Album)   collection = 'album';
    else if(T == Song)    collection = 'song';
    else if(T == Playlist) collection = 'playlist';

    print('=== _getCollection $T');

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

    _total = await promiseToFuture(_collection.aggregate(js.jsify(countPipeline)).first())
      .then((result) {
        int value = result != null ? js.getProperty(result, 'count') : 0;
        return value;
      });
  }

  Future<List<T>> loadNextPage([int goto]) async
  {
    if(goto != null) _current = goto;
    else _current += 1;

    Map navigatorDetail = getNavigatorDetail(total: _total, page: _current, perPage: _perPage);

    List artistsPipeline = _getMainStages();
    artistsPipeline.addAll([
        {
          '\$skip' : navigatorDetail['from']
        },

        {
          '\$limit': navigatorDetail['to']
        }
      ]);

    dynamic artistDocs = await promiseToFuture(
      _collection.aggregate(js.jsify(artistsPipeline)).asArray())
      .catchError(_handleError);

    list = [];
    artistDocs.forEach((doc) 
    {
      Map maped = convertToMap(doc, getDbFields<T>());
      list.add(createItemFromDoc<T>(maped));
    });

    if(_current < navigatorDetail['pages']) 
      hasMore = true;
    else hasMore = false;

    return list;
  }

  Exception _handleError(dynamic e) {
      print(e); // for demo purposes only
      return Exception('ArtistsExplorerComponent error; cause: $e');
    }
}
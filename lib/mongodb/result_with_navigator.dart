/// {@nodoc}
library resultWithNavigator;

import 'dart:async';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

enum GetType {mediaItems, favorites, history}

class ResultWithNavigator<T>
{
  Aggregate _aggregator; 

  int _pages = 0;
  int _perPage;
  int _current = 0;

  String database;
  String collection;

  bool hasMore = false;

  GetType getType;
  Map customQuery;
  Map customSort;

  List<T> list = [];

  ResultWithNavigator({this.getType = GetType.mediaItems, 
    this.customQuery, this.customSort, int perPage=20})
  {
    _perPage = perPage;
    collection = getCollection<T>();
    initialize();
  }

  static createItemFromDoc<T>(Map doc, {dontGetSongs= true})
  {
    T item;

    if(T == Artist)       item = Artist.fromjson(doc) as T;
    else if(T == Album)   item = Album.fromjson(doc, dontGetSongs: dontGetSongs) as T;
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

  List<Map> getPiplines()
  {
    List<Map> piplines = [];

    // get mediaItems
    if(getType == GetType.mediaItems)
    {
      if(customQuery != null)
        piplines.add({ '\$match': customQuery });

      if(customSort != null)
        piplines.add({ '\$sort': customSort });
    }

    // get favorites or history
    else if (getType == GetType.favorites || getType == GetType.history)
    {
      // argumants = js.jsify(['song_favorite', _perPage, _current]);
      // method = _stitch.appClient.callFunction('getUserSongs', argumants);
      String userid = Injector.get<UserService>().user.id;
      piplines = [
        { '\$match': { 'refId': userid } },
      ];
    }

    piplines.add({ '\$sort': {'_id': -1} });

    return piplines;
  }

  Map getAccessQuery()
  {
    Map query = {};
    
    if(getType == GetType.favorites || getType == GetType.history)
      query = { 'refId': Injector.get<UserService>().user.id };

    return query;
  }

  void initialize()
  {
    // set database
    if(getType == GetType.mediaItems)
      database = 'media';
    else database = 'user';

    // set collection again
    if (getType == GetType.favorites)
      collection = 'song_favorite';
    else if (getType == GetType.history)
      collection = 'song_history';

    _aggregator = Aggregate(
      database: database,
      collection: collection, 
      pipline: getPiplines(),
      accessQuery: getAccessQuery(),
      perPage: _perPage);
  }

  Future<List<T>> loadNextPage({int goto, bool resetList=false}) async
  {
    if(goto != null) _current = goto;
    else _current += 1;

    if(!_aggregator.isInitialized)
      await _aggregator.initialize();

    dynamic docs = await _aggregator.loadNextPage(goto: goto)
      .then((list) async
        {
          if(getType != GetType.mediaItems)
            return await _getItemFromIds(list);
          return list;
        });

    _pages = _aggregator.pages;

    if(resetList) list = [];

    docs.forEach((doc) {
      Map maped = validateFields(doc, getDbFields<T>());
      list.add(createItemFromDoc<T>(maped));
    });

    if(_current < _pages) 
      hasMore = true;
    else hasMore = false;

    //print('loadNextPage list ${list.length}');
    return list;
  }

  Exception _handleError(dynamic e) {
      print(e); // for demo purposes only
      return Exception('ArtistsExplorerComponent error; cause: $e');
    }

  Future<dynamic> _getItemFromIds(List<dynamic> trackedSongs) async
  {
    List<String> ids = [];

    trackedSongs.forEach((doc) 
      {
        ids.add(doc['songId']);
      });

    List<dynamic> docs = [];

    if(ids.length > 0)
    {
      docs = await Injector.get<MongoDBService>()
        .findByIds(database: 'media', collection: 'song', ids: ids);
    }

    docs.sort((a, b)
    {
      int aNum = ids.indexOf(a['_id'].toString());
      int bNum = ids.indexOf(b['_id'].toString());

      return aNum.compareTo(bNum);
    });

    return docs;
  }
}
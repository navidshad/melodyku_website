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

    String coll = _getCollection<T>();
    //print('ResultWithNavigator collection $coll');
    _collection = Injector.get<StitchService>().dbClient.db('media').collection(coll);
  }

  List<T> _generateListOfItems<T>(List rawItems)
  {
    List<T> items = [];

    //print('rawItems length ${rawItems.length}');

    switch(T)
    {
      case Artist: rawItems.forEach((artistObject) 
        => items.add(Artist.fromjson(artistObject) as T)); break;
      
      case Album: rawItems.forEach((albumObject) 
        => items.add(Album.fromjson(albumObject) as T)); break;
      
      case Song: rawItems.forEach((songObject) 
        => items.add(Song.fromjson(songObject) as T)); break;

      // case Playlist: rawItems.forEach((playlistObject) 
      //   => items.add(Playlist.fromjson(playlistObject) as T)); break;
    }

    //print('items length ${items.length}');
    return items;
  }

  List<DbField> _getDbFields<T>()
  {
    List<DbField> list = [];

    switch(T)
    {
      case Artist:  list = SystemSchema.artist;   break;
      case Album:   list = SystemSchema.album;    break;
      case Song:    list = SystemSchema.song;     break;
      //case Playlist:list = SystemSchema.; break;
    }

    return list;
  }

  String _getCollection<T>()
  {
    String collection = '';

    switch(T)
    {
      case Artist:  collection = 'artist'; break;
      case Album:   collection = 'album'; break;
      case Song:    collection = 'song'; break;
      case Playlist:collection = 'playlist'; break;
    }

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

    List covertedDocs = artistDocs.map((doc) =>
        convertToMap(doc, _getDbFields<T>())).toList();

    list = _generateListOfItems<T>(covertedDocs);

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
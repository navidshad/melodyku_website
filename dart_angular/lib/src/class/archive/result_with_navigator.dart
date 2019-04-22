import 'album.dart';
import 'artist.dart';
import 'song.dart';
import 'playlist.dart';
import 'package:melodyku/mongo_stitch/mongo_stitch.dart';


class ResultWithNavigator<T>
{
  int pages;
  int current;
  List<T> list;

  ResultWithNavigator({this.pages, this.current, this.list});

  factory ResultWithNavigator.fromMongoStitchResult(dynamic result, List<DbField> itemFields)
  {
    print('ResultWithNavigator fromMongoStitchResult');
    // add navigator Dbfield items
    List<DbField> fields = [
      DbField('pages', dataType: DataType.int),
      DbField('current', dataType: DataType.int),
      DbField('list', dataType: DataType.array_object, subFields: itemFields),
    ];

    // convert stitch result to map
    Map mapResult = convertToMap(result, fields);

    //print('result, ${result}, mapResult ${mapResult}');
    //mapResult.keys.toList().forEach((key) => print(key));

    return ResultWithNavigator<T>(
      pages   : mapResult['pages'],
      current : mapResult['current'],
      list    : _generateListOfItems<T>(mapResult['list'])
    );
  }

  static List<T> _generateListOfItems<T>(List rawItems)
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

      case Playlist: rawItems.forEach((playlistObject) 
        => items.add(Playlist.fromjson(playlistObject) as T)); break;
    }

    //print('items length ${items.length}');
    return items;
  }
}
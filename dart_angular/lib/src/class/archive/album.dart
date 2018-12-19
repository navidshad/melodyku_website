import 'media_item.dart';
import '../types.dart';

class Album extends MediaItem
{
  String name;
  String singer;
  String description;
  String thumbnail;

  Album(id, ArchiveTypes type, {this.name, this.singer, this.description, this.thumbnail})
    : super(id, type);

  factory Album.fromjson(dynamic detail)
  {
    Album album;
    try {
      album = Album(

        (detail['_id'] != null) ? detail['_id'] : '',
        ArchiveTypes.album,

        name: (detail['name']) ? detail['name'] : '',
        singer: (detail['singer']) ? detail['singer'] : '',
        description: (detail['description']) ? detail['description'] : '',
        thumbnail: (detail['thumbnail']) ? detail['thumbnail'] : '',
        );
    } 
    catch (e) {
      print('convert album from json $detail');
      print(e);
    }

    return album;
  }

  dynamic toDynamic()
  {
    return {
      'name'   : name,
      'singer' : singer,
      'description' : description,
      'thumbnail'   : thumbnail,
    };
  }
}
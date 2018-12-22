import 'package:melodyku/src/class/archive/media_item.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Singer implements MediaItem
{
  dynamic id;
  ArchiveTypes type;

  String name;
  String description;
  String thumbnail;

  Singer({this.id, this.name, this.description, this.thumbnail});

  factory Singer.fromjson(dynamic detail)
  {
    Singer singer;
    try {
      singer =  Singer(
        id: (detail['_id'] != null) ? detail['_id'] : '',
        name: (detail['name']) ? detail['name'] : '',
        description: (detail['description']) ? detail['description'] : '',
        thumbnail: (detail['thumbnail']) ? detail['thumbnail'] : '',
        );
    } 
    catch (e) {
      print('convert singer from json $detail');
      print(e);
    }
    return singer;
  }

  dynamic toDynamic()
  {
    return {
      'name'        : name,
      'description' : description,
      'thumbnail'   : thumbnail
    };
  }

  @override
  Future<bool> getLikeStatus() {
    // TODO: implement getLikeStatus
    return null;
  }

  @override
  Future<bool> getPlayStatus() {
    // TODO: implement getPlayStatus
    return null;
  }

  @override
  Future<bool> like() {
    // TODO: implement like
    return null;
  }

  @override
  void play() {
    // TODO: implement play
  }

  @override
  T getAsWidget<T>({int itemNumber=1}) {
    T widget;
    Uri thumbnail = Uri(path: getRandomCovers(1)[0]);

    switch(T)
    {
      case Card:
        widget = Card( name,
            id: id,
            thumbnail: thumbnail,
            type: ArchiveTypes.singer,
            origin: toDynamic()
        ) as T;
        break;

      case ListItem:
        String digititemNumber = getDigitStyle(itemNumber+1, 2);
        widget = ListItem(name,
            id: id,
            duration: '',
            number: digititemNumber,
            thumbnail: thumbnail,
            type: ArchiveTypes.singer,
            origin: toDynamic()
        ) as T;
        break;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T>()
  {
    return <T>[getAsWidget<T>()];
  }
}
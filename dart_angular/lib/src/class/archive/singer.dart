import 'package:melodyku/src/class/archive/media_item.dart';

import '../classes.dart';

import '../injector.dart' as CI;
import '../../routting/routes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Singer implements MediaItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked;

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
        name: (detail['name'] != null) ? detail['name'] : '',
        description: (detail['description'] != null) ? detail['description'] : '',
        thumbnail: (detail['thumbnail'] != null) ? detail['thumbnail'] : getRandomCovers(1)[0],
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
  String get link => '/#artist/$id';

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

    Map<String, String> params = {'id':id.toString()};
    String link = '#${CI.Injector.get<PageRoutes>().getRouterUrl('artist', params)}';

    switch(T)
    {
      case Card:
        widget = Card( name,
            id: id,
            thumbnail: thumbnail,
            titleLink: link,
            type: ArchiveTypes.singer,
            origin: this
        ) as T;
        break;

      case ListItem:
        String digititemNumber = getDigitStyle(itemNumber+1, 2);
        widget = ListItem(name,
            id: id,
            duration: '',
            number: digititemNumber,
            thumbnail: thumbnail,
            titleLink: link,
            type: ArchiveTypes.singer,
            origin: this
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
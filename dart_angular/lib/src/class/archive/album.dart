import 'package:melodyku/src/class/archive/media_item.dart';

import '../injector.dart' as CI;
import '../../routting/routes.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Album implements MediaItem
{
  dynamic id;
  ArchiveTypes type;

  List<Media> list;

  String name;
  String singer;
  String description;
  String thumbnail;

  Album({this.id, this.type, this.name, this.singer, this.list, this.description, this.thumbnail});

  factory Album.fromjson(dynamic detail)
  {
    Album album;
    try {

      List<Media> items = [];

      if(detail['medias'] != null)
      {
        detail['medias'].forEach((item) 
        { items.add(Media.fromjson(item)); });
      }
      
      album = Album(
        id: (detail['_id'] != null) ? detail['_id'] : '',
        type: ArchiveTypes.album,
        name: (detail['name'] != null) ? detail['name'] : '',
        singer: (detail['singer'] != null) ? detail['singer'] : '',
        description: (detail['description'] != null) ? detail['description'] : '',
        thumbnail: (detail['thumbnail'] != null) ? detail['thumbnail'] : getRandomCovers(1)[0],
        list: items,
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

  @override
  String get link => '/#album/$id';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    Map<String, String> params = {'id':id};
    String link = '#${CI.Injector.get<PageRoutes>().getRouterUrl('album', params)}';

    switch(T)
    {
      case Card:
        widget = Card( name,
          id: id,
          thumbnail: Uri(path: thumbnail),
          type: ArchiveTypes.album,
          origin: this,
          subtitle: singer,
          titleLink: link,
        ) as T;
        break;

      case ListItem:
        String digititemNumber = getDigitStyle(itemNumber+1, 2);
        widget = ListItem(name,
          id: id,
          duration: '',
          number: digititemNumber,
          thumbnail: Uri(path: thumbnail),
          type: ArchiveTypes.album,
          origin: this,
          subtitle: singer,
          titleLink: link,
        ) as T;
        break;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T>({int total = 1})
  {
    List<T> items = [];

    for(int i=0; i < total; i++)
    {
      Media item = list[i];
      item.thumbnail = getRandomCovers(1)[0];
      String itemNumber = getDigitStyle(i+1, 2);

      switch(T)
      {
        case Card:
          T card = Card( item.title,
              id: item.id,
              thumbnail: Uri(path: item.thumbnail),
              type: ArchiveTypes.media,
              origin: item
          ) as T;

          items.add(card);
          break;

        case ListItem:
          T listITem = ListItem(item.title,
              id: item.id,
              duration: item.getDuration(),
              number: itemNumber,
              thumbnail: Uri(path: item.thumbnail),
              type: ArchiveTypes.media,
              origin: item
          ) as T;

          items.add(listITem);
          break;
      }
    }
    return items;
  }

  @override
  Future<bool> getLikeStatus() {
    // TODO: implement getLikeStatus
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
  Future<bool> getPlayStatus() {
    // TODO: implement getPlayStatus
    return null;
  }

  @override
  bool isLiked;
}
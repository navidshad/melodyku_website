import 'package:melodyku/src/class/archive/media_item.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';

class Playlist implements MediaItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked;

  String title;
  List<Media> list;
  String thumbnail;

  Playlist({this.id, this.title, this.list, this.thumbnail});

  factory Playlist.fromjson(dynamic detail)
  {
    Playlist playlist;
    try {
      List<Media> items = (detail['list'] as List)
      .map((item) => Media.fromjson(item) ).toList();
      playlist = Playlist( id: detail['_id'], title: detail['name'], thumbnail: detail['thumbnail'], list: items );
    } 
    catch (e) {
      print('convert playlist from json');
      print(e);
    }
    return playlist;
  }

  dynamic toDynamic()
  {
    return {
      'name': title, 
      'thumbnail': thumbnail, 
      'list': list.map((media){media.toDynamic();})
      };
  }

  String getDuration()
  {
    int length = 0;
    list.forEach((media){ length += media.duration; });

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    String durationStr;
    if(hours > 0) durationStr += '$hours : ';
    durationStr += '$minutes : $seconds';

    return durationStr;
  }

  @override
  String get link => '/#playlist/$id';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;
    Uri thumbnail = Uri(path: getRandomCovers(1)[0]);

    switch(T)
    {
      case Card:
        widget = Card( title,
            id: id,
            thumbnail: thumbnail,
            type: ArchiveTypes.playlist,
            origin: this
        ) as T;
        break;

      case ListItem:
        String digititemNumber = getDigitStyle(itemNumber+1, 2);
        widget = ListItem(title,
            id: id,
            duration: '',
            number: digititemNumber,
            thumbnail: thumbnail,
            type: ArchiveTypes.playlist,
            origin: this
        ) as T;
        break;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T>({int total = 1})
  {
    //print('getChildsAsWidgets ${list.length.toString()} ${T}');
    List<T> items = [];

    int totalTemp = total <= list.length ? total : list.length;

    for(int i=0; i < totalTemp; i++)
    {
      Media item = list[i];
      item.thumbnail = getRandomCovers(1)[0];
      String itemNumber = getDigitStyle(i+1, 2);

      switch(T)
      {
        case Card:
        //print('child is card');
          T card = Card<Media>( item.title,
              id: item.id,
              thumbnail: Uri(path: item.thumbnail),
              type: ArchiveTypes.media,
              origin: item
          ) as T;

          items.add(card);
          break;

        case ListItem:
          //print('child is listItem');
          T listITem = ListItem<Media>(item.title,
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
}
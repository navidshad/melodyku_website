import 'package:melodyku/src/class/archive/media_item.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';

class Playlist implements MediaItem
{
  dynamic id;
  ArchiveTypes type;

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

  // methods
//  List<Card> getCardList([int total]) =>
//    ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);
//
//  List<ListItem> getItemList([int total]) =>
//    ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);

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
            origin: toDynamic()
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
            origin: toDynamic()
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
              origin: item.toDynamic()
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
              origin: item.toDynamic()
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
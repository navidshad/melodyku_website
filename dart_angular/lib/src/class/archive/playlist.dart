import 'package:melodyku/src/class/archive/media_item.dart';
import 'dart:async';
import '../classes.dart';

import '../injector.dart' as CI;
import '../../routting/routes.dart';

import 'media_item.dart';
import '../types.dart';

class Playlist implements SongItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked;

  String title;
  List<Song> list;
  String thumbnail;

  Playlist({this.id, this.title, this.list, this.thumbnail});

  factory Playlist.fromjson(Map detail)
  {
    Playlist playlist;
    try {
      List<Song> items = [];

      if(detail.containsKey('list'))
      {
        List songMaps = detail['list'];

        songMaps.forEach((item) { 
          Song newSong = Song.fromjson(item);
          items.add(newSong); 
        });
      }

      playlist = Playlist( 
        id: detail['_id'].toString(), 
        title: detail['title'], 
        thumbnail: getRandomCovers(1)[0], 
        list: items );
    } 
    catch (e) {
      print('convert playlist from json');
      print('$e | $detail[]');
    }
    return playlist;
  }

  dynamic toDynamic()
  {
    return {
      'name': title, 
      'thumbnail': thumbnail, 
      //'list': list.map((media){media.toDynamic();})
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

    Map<String, String> params = {'id':id};
    String link = '#${CI.Injector.get<PageRoutes>().getRouterUrl('playlist', params)}';
    
    if(T == Card)
    {
      widget = Card( title,
          id: id,
          thumbnail: Uri(path: thumbnail),
          titleLink: link,
          type: ArchiveTypes.playlist,
          origin: this
      ) as T;
    }
    else if(T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(title,
          id: id,
          duration: '',
          number: digititemNumber,
          thumbnail: Uri(path: thumbnail),
          titleLink: link,
          type: ArchiveTypes.playlist,
          origin: this
      ) as T;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T> ({int total = 1})
  {
    //print('getChildsAsWidgets ${list.length.toString()} ${T}');
    List<T> items = [];

    int totalTemp = total <= list.length ? total : list.length;

    for(int i=0; i < totalTemp; i++)
    {
      Song item = list[i];
      item.thumbnail = getRandomCovers(1)[0];
      String itemNumber = getDigitStyle(i+1, 2);

      T widget;

      if(T == Card)
      {
        //print('create Card from playlist items: ${item.title}');
        widget = Card<Song>( 
          item.title,
          subtitle: item.artist,
          id: item.id,
          thumbnail: Uri(path: item.thumbnail),
          type: ArchiveTypes.media,
          origin: item
        ) as T;
      }
      else if(T == ListItem)
      {
        //print('create ListItem from playlist items: ${item.title}');
        widget = ListItem<Song>(
          item.title,
          subtitle: item.artist,
          id: item.id,
          duration: item.getDuration(),
          number: itemNumber,
          thumbnail: Uri(path: item.thumbnail),
          type: ArchiveTypes.media,
          origin: item
        ) as T;
      }

      items.add(widget);
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
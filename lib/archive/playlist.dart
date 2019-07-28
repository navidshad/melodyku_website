/// {@nodoc}
library playlist;

import 'dart:async';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

import 'media_item.dart';
import 'song.dart';
import 'package:melodyku/core/types.dart';

class Playlist implements MediaItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked;

  String title;
  List<Song> list;
  String thumbnail;
  String imgStamp;

  Map localTitle;

  Playlist({this.id, this.title, this.list, 
    this.thumbnail, this.imgStamp, this.localTitle})
  {
    // get thumbnail link
    thumbnail = Injector.get<ContentProvider>().getImage(type:'playlist', id:id, imgStamp:imgStamp);
  }

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
        id        : detail['_id'].toString(), 
        title     : detail['title'], 
        imgStamp  : (detail['imgStamp']   != null) ? detail['imgStamp'] : '',
        list      : items,
        localTitle: (detail['local_title'] != null) ? detail['local_title'] : {},
        );
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
    double length = 0;
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
  String get link => '#${Injector.get<PageRoutes>().getRouterUrl('playlist', {'id': id})}';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;
    
    if(T == Card)
    {
      widget = Card( title,
          id: id,
          thumbnail: thumbnail,
          titleLink: link,
          type: ArchiveTypes.playlist,
          origin: this,

      ) as T;
    }
    else if(T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(title,
          id: id,
          duration: '',
          number: digititemNumber,
          thumbnail: thumbnail,
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
      String itemNumber = getDigitStyle(i+1, 2);

      T widget;

      if(T == Card)
      {
        //print('create Card from playlist items: ${item.title}');
        widget = Card<Song>( 
          item.title,
          subtitle: item.artist,
          subtitleLink: item.link_artist,
          id: item.id,
          thumbnail: item.thumbnail,
          type: ArchiveTypes.media,
          origin: item,
          localTitle: item.localTitle,
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
          thumbnail: item.thumbnail,
          type: ArchiveTypes.media,
          origin: item,
          localTitle: item.localTitle,
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
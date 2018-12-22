import 'dart:convert';
import 'package:melodyku/src/class/archive/media_item.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Media implements MediaItem
{
  dynamic id;
  ArchiveTypes type;

  String title;
  String singer;
  String album;
  List<String> genre;
  String lyric;
  String thumbnail;

  int year;
  int duration;

  Media({
    this.id,
    this.title, 
    this.singer, 
    this.album, 
    this.year, 
    this.genre,
    this.lyric,
    this.duration,
    this.thumbnail,
  });

  factory Media.fromjson(dynamic detail)
  {
    List<String> genre_list = (detail['genre'] as List).map((gn) => gn.toString()).toList();
    Media mFromJson;
    try {
      mFromJson = Media(
      id: (detail['_id'] != null) ? detail['_id'] : '',
      title: (detail['title'] != null) ? detail['title'] : '',
      singer: (detail['albumartist'] != null) ? detail['albumartist'] : '',
      album: (detail['album'] != null) ? detail['album'] : '',
      genre: (detail['genre'] != null) ? genre_list : '',
      lyric: (detail['lyric'] != null) ? detail['lyric'] : '',
      year: (detail['year']   != null) ? detail['year'] : null,
      duration: (detail['duration']   != null) ? detail['duration'] : 0,
      thumbnail: (detail['thumbnail']   != null) ? detail['thumbnail'] : '',
    );

    if(detail['titleIndex'] != null) mFromJson.title = (detail['titleIndex']['ku_fa']).toString().trim();

    } catch (e) {
      print('convert Media from json ${json.encode(detail)}');
      print(e);
    }

    return mFromJson;
  }

  dynamic toDynamic()
  {
    return {
      '_id'         : id,
      'title'       : title,
      'albumartist' : singer,
      'album'       : album,
      'year'        : year,
      'genre'       : genre,
      'lyric'       : lyric,
      'duration'    : duration,
      'thumbnail'   : thumbnail,
    };
  }

  String getDuration([num customLength])
  {
    int length = 0;
    if(customLength != null && !customLength.isNaN) length = customLength.toInt();
    else if(duration != null) length = duration;

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    String durationStr = '';
    if(hours > 0) durationStr += '$hours : ';
    durationStr += '$minutes : $seconds';

    return durationStr;
  }

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;
    String thumbnail = getRandomCovers(1)[0];

    switch(T)
    {
      case Card:
        widget = Card( title,
            id: id,
            thumbnail: Uri(path: thumbnail),
            type: ArchiveTypes.media,
            origin: toDynamic()
        ) as T;
        break;

      case ListItem:
        String digititemNumber = getDigitStyle(itemNumber+1, 2);
        widget = ListItem(title,
            id: id,
            duration: getDuration(),
            number: digititemNumber,
            thumbnail: Uri(path: thumbnail),
            type: ArchiveTypes.media,
            origin: toDynamic()
        ) as T;
        break;
    }
  }

  @override
  List<T> getChildsAsWidgets<T>()
  {
    return <T>[getAsWidget<T>()];
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
}
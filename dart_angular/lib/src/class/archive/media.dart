import 'dart:convert';
import 'dart:async';
import 'package:melodyku/src/class/archive/media_item.dart';

import '../injector.dart';
import '../../services/content_provider/requester.dart';
import '../../services/user_service.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

import '../../services/urls.dart';

class Media implements MediaItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked = false;

  String title;
  String artist;
  String album;
  List<String> genre;
  String lyric;
  String thumbnail;

  int year;
  int duration;

  Media({
    this.id,
    this.title, 
    this.artist, 
    this.album, 
    this.year, 
    this.genre,
    this.lyric,
    this.duration,
    this.thumbnail,
  })
  {
    type = ArchiveTypes.media;
    getLikeStatus();
  }

  factory Media.fromjson(dynamic detail)
  {
    List<String> genre_list = [];

    if(detail['genre'] != null)
      detail['genre'].forEach((gn) { genre_list.add(gn.toString()); } );

    Media mFromJson;
    try {
      mFromJson = Media(
      id: (detail['_id'] != null) ? detail['_id'] : '',
      title: (detail['title'] != null) ? detail['title'] : '',
      artist: (detail['albumartist'] != null) ? detail['albumartist'] : '',
      album: (detail['album'] != null) ? detail['album'] : '',
      genre: genre_list,
      lyric: (detail['lyric'] != null) ? detail['lyric'] : '',
      year: (detail['year']   != null) ? detail['year'] : null,
      duration: (detail['duration']   != null) ? detail['duration'] : 0,
      thumbnail: (detail['thumbnail']   != null) ? detail['thumbnail'] : getRandomCovers(1)[0],
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
      'albumartist' : artist,
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
  String get link => '/#media/$id';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    if(T == Card)
    {
      widget = Card( 
        title,
        subtitle: artist,
        id: id,
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.media,
        origin: this
      ) as T;
    }

    else if(T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(
        title,
        subtitle: artist,
        id: id,
        duration: getDuration(),
        number: digititemNumber,
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.media,
        origin: this
      ) as T;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T>()
  {
    return <T>[getAsWidget<T>()];
  }

  @override
  Future<bool> getLikeStatus() async
  {
    Requester rq = Injector.get<Requester>();
    UserService userService = Injector.get<UserService>();

    if(!userService.isLogedIn) return false;

    dynamic form = {
      'userid': userService.user.id,
      'item': id,
    };

    dynamic result = await rq.post('${link_api_user}/favorite/check', body: form);
    isLiked = result['liked'];

    return isLiked;
  }

  @override
  Future<bool> like() async
  {
    isLiked = !isLiked;
    Requester rq = Injector.get<Requester>();
    UserService userService = Injector.get<UserService>();

    dynamic form = {
        'userid': userService.user.id,
        'type': 'media',
        'id': id
    };

    dynamic result = await rq.post('${link_archive}/like', body: form);
    isLiked = result['liked'];

    return isLiked;
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
import 'dart:convert';
import 'dart:async';
import 'package:melodyku/src/class/archive/media_item.dart';
import 'package:js/js_util.dart' as js;

import '../injector.dart';
import '../../services/services.dart';


import '../classes.dart';

import 'media_item.dart';
import 'song_version.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Song implements SongItem
{
  String id;
  String artistId;
  String albumId;

  ArchiveTypes type;
  bool isLiked = false;

  String title;
  String artist;
  String album;
  List<String> genre;
  String lyric;
  String thumbnail;

  int year;
  double duration;

  List<SongVersion> versions = [];

  Song({
    this.id,
    this.artistId,
    this.albumId,
    this.title, 
    this.artist, 
    this.album, 
    this.year, 
    this.genre,
    this.lyric,
    this.duration,
    this.thumbnail,
    this.versions,
  })
  {
    type = ArchiveTypes.media;
    getLikeStatus();
    //_getVersions();
  }

  factory Song.fromjson(Map detail)
  {
    List<String> genre_list = [];
    List<SongVersion> versions = [];

    // if(detail['genre'] != null)
    //   detail['genre'].forEach((gn) { genre_list.add(gn.toString()); } );

    if(detail.containsKey('versions'))
      versions = Song.createVersions(detail['versions']);

    Song mFromJson;
    try {
      //print('Song.fromjson $detail');

      mFromJson = Song(
      id        : (detail['_id'] != null) ? detail['_id'].toString() : '',
      artistId  : (detail['artistId'] != null) ? detail['artistId'] : '',
      albumId   : (detail['albumId'] != null) ? detail['albumId'] : '',
      title     : (detail['title'] != null) ? detail['title'] : '',
      artist    : (detail['artist'] != null) ? detail['artist'] : '',
      album     : (detail['album'] != null) ? detail['album'] : '',
      genre     : genre_list,
      lyric     : (detail['lyric'] != null) ? detail['lyric'] : '',
      year      : (detail['year']   != null) ? detail['year'] : null,
      duration  : (detail['duration']   != null) ? detail['duration'] : 0,
      thumbnail : (detail['thumbnail']   != null) ? detail['thumbnail'] : getRandomCovers(1)[0],
      versions  : versions,
    );

    //if(detail['titleIndex'] != null) mFromJson.title = (detail['titleIndex']['ku_fa']).toString().trim();

    } catch (e) {
      print('convert Song from json ${json.encode(detail)}');
      print(e);
    }

    return mFromJson;
  }

  static List<SongVersion> createVersions(String json)
  {
    List docs = [];

    try{
      docs = jsonDecode(json);
    }catch(e) {
      print('createVersions $json $e');
    };

    List<SongVersion> versions = [];
    for(int i=0; i < docs.length; i++)
      {
        dynamic doc = docs[i];
        SongVersion v = SongVersion.createFromMap(doc);
        if(v != null) versions.add(v);
      }

    return versions;
  }

  dynamic toDynamic()
  {
    return {
      '_id'         : id,
      'title'       : title,
      'artist'      : artist,
      'album'       : album,
      'year'        : year,
      'genre'       : genre,
      'lyric'       : lyric,
      'duration'    : duration,
      'thumbnail'   : thumbnail,
    };
  }

  String getDuration()
  {
    int length = duration.floor() ?? 0;

    //if(length > 0) length = (length / 10);

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    String durationStr = '';
    durationStr += '$seconds : $minutes';
    if(hours > 0) durationStr += '$hours : ';

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
        artist,
        subtitle: title,
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
        artist,
        subtitle: title,
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
    //Requester rq = Injector.get<Requester>();
    UserService userService = Injector.get<UserService>();

    // if(!userService.isLogedIn) return false;

    // dynamic form = {
    //   'userid': userService.user.id,
    //   'item': id,
    // };

    // dynamic result = await rq.post('${link_api_user}/favorite/check', body: form);
    // isLiked = result['liked'];

    if(userService.isLogedIn)
      isLiked = await userService.user.traker.getLikeStatus(id, type: type);
    
    return isLiked;
  }

  @override
  Future<bool> like() async
  {
    isLiked = !isLiked;
    // Requester rq = Injector.get<Requester>();
    // UserService userService = Injector.get<UserService>();

    // dynamic form = {
    //     'userid': userService.user.id,
    //     'type': 'media',
    //     'id': id
    // };

    // dynamic result = await rq.post('${link_archive}/like', body: form);
    // isLiked = result['liked'];

    // return isLiked;
    UserService userService = Injector.get<UserService>();

    if(!userService.isLogedIn) return false;

    isLiked = await userService.user.traker.reportLikedSong(this);

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
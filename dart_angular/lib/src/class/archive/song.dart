import 'dart:convert';
import 'dart:async';
import 'package:melodyku/src/class/archive/media_item.dart';
import 'package:js/js_util.dart' as js;
import 'package:http/http.dart';

import '../injector.dart' as CI;
import '../../routting/routes.dart';

import '../injector.dart';
import '../../services/services.dart';
import '../../services/urls.dart';


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
  double duration, size;
  int bitrate;

  String imgStamp;
  String imgStamp_album;
  String imgStamp_artist;


  List<Map> versions = [];

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
    this.bitrate,
    this.size,
    this.thumbnail,
    this.versions,
    this.imgStamp,
    this.imgStamp_album,
    this.imgStamp_artist
  })
  {
    type = ArchiveTypes.media;
    getLikeStatus();

    // get thumbnail link
    this.thumbnail = Injector.get<ContentProvider>().
      getImage(type:'song', id:id, imgStamp:imgStamp, 
        imgStamp_album: imgStamp_album, imgStamp_artist: imgStamp_artist,
        albumId: albumId, artistId: artistId);
  }

  factory Song.fromjson(Map detail)
  {
    List<String> genre_list = [];
    List<SongVersion> versions = [];

    // if(detail['genre'] != null)
    //   detail['genre'].forEach((gn) { genre_list.add(gn.toString()); } );

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
      bitrate   : (detail['bitrate']   != null) ? detail['bitrate'] : 0,
      size      : (detail['size']   != null) ? detail['size'] : 0,
      imgStamp  : (detail['imgStamp']   != null) ? detail['imgStamp'] : '',
      imgStamp_album  : (detail['imgStamp_album']   != null) ? detail['imgStamp_album'] : '',
      imgStamp_artist  : (detail['imgStamp_artist']   != null) ? detail['imgStamp_artist'] : '',
      versions  : detail['versions'],
    );

    //if(detail['titleIndex'] != null) mFromJson.title = (detail['titleIndex']['ku_fa']).toString().trim();

    } catch (e) {
      print('convert Song from json ${json.encode(detail)}');
      print(e);
    }

    return mFromJson;
  }

  Future<String> getStreamLink(String version, String userid) async
  {
    String cBitrate;
    bool isOrginal = false;

    if(version == 'original')
    {
      cBitrate = bitrate.toString();
      isOrginal = true;
    }

    else {
      versions.forEach((Map SongVersion) {
        if(SongVersion['title'] == version)
          cBitrate = SongVersion['title'];
      });
    }

    // create stream link
    Uri link = Uri.http(window.location.host, 'stream', 
      {'ai': artistId, 'si': id, 'br': cBitrate, 'org': isOrginal.toString()});

    return link.toString();
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
  String get link => '#${CI.Injector.get<PageRoutes>().getRouterUrl('song', {'id': id})}';
  String get list_album => '#${CI.Injector.get<PageRoutes>().getRouterUrl('album', {'id': albumId})}';
  String get list_artist => '#${CI.Injector.get<PageRoutes>().getRouterUrl('artist', {'id': artistId})}';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    if(T == Card)
    {
      widget = Card( 
        title,
        subtitle: artist,
        subtitleLink: list_artist,
        id: id,
        thumbnail: thumbnail,
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
        thumbnail: thumbnail,
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
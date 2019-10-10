/// {@nodoc}
library song;

import 'dart:convert';
import 'dart:async';
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

import 'media_item.dart';
import 'album.dart';
import 'artist.dart';
//import 'download_file.dart';

class Song implements MediaItem
{
  String id;
  // String artistId;
  // String albumId;

  ArchiveTypes type;
  bool isLiked = false;

  bool isLocal = false;
  int storedDate;

  String title;
  Artist artist;
  Album album;
  List<String> categories;
  String lyric;
  String thumbnail;

  int year;
  double duration, size;
  double bitrate;

  String imgStamp;
  String imgStamp_album;
  String imgStamp_artist;

  Map localTitle;

  List<Map> versions = [];

  Song({
    this.id,
    // this.artistId,
    // this.albumId,
    this.title, 
    this.artist, 
    this.album, 
    this.year, 
    this.categories,
    this.lyric,
    this.duration,
    this.bitrate,
    this.size,
    this.thumbnail,
    this.versions,
    this.imgStamp='',
    this.imgStamp_album='',
    this.imgStamp_artist='',
    this.isLocal = false,
    this.storedDate = 0,

    this.localTitle=const{},
  })
  {
    type = ArchiveTypes.song;
    getLikeStatus();

    // get thumbnail link
    getThumbnailLink();
  }

  factory Song.fromjson(Map detail, {Artist artist, Album album, isLocal = false})
  {
    Song mFromJson;
    try {
      //print('Song.fromjson $detail');
      mFromJson = Song(
      id        : detail['_id'],
      title     : detail['title'],
      // artistId  : detail['artistId'],
      // albumId   : detail['albumId'],
      artist    : artist,
      album     : album,
      categories: detail['categories'],
      lyric     : detail['lyric'],
      year      : detail['year'],
      duration  : detail['duration'],
      bitrate   : detail['bitrate'],
      size      : detail['size'],
      imgStamp  : detail['imgStamp'],
      imgStamp_album  : detail['imgStamp_album'],
      imgStamp_artist  : detail['imgStamp_artist'],
      versions  : detail['versions'],
      localTitle: detail['local_title'],

      isLocal   : isLocal,
      storedDate : (detail.containsKey('storedDate')) ? detail['storedDate'] : 0,
    );

    } catch (e) {
      print(e);
      print('convert Song from json ${json.encode(detail)}');
    }

    return mFromJson;
  }

  factory Song.fromPopulatedDoc(Map detail, {isLocal = false})
  {
    Song song;

    try{

      Artist artist = Artist.fromjson(detail['artistId']);
      Album album = Album.fromjson(detail['albumId'], artist: artist);
      song = Song.fromjson(detail, artist: artist, album: album, isLocal: isLocal);

      }catch(e){
        print(e);
        print('convert Song fromPopulatedDoc ${json.encode(detail)}');
      }

    return song;
  }

  Map getAsMap()
  {
    return {
      '_id'       : id,
      // 'artistId'  : artistId,
      // 'albumId'   : albumId,
      'title'     : title,
      'artist'    : artist?.name,
      'album'     : album?.title,
      'categories': categories,
      'lyric'     : lyric,
      'year'      : year,
      'duration'  : duration,
      'bitrate'   : bitrate,
      'size'      : size,
      'imgStamp'  : imgStamp,
      'imgStamp_album'  : imgStamp_album,
      'imgStamp_artist'  : imgStamp_artist,
      'versions'  : versions,
      'localTitle': localTitle,
    };
  }

  void getThumbnailLink() async
  {
    String link;

    // if(isLocal)
    // {
    //   await Injector.get<IndexedDBService>()
    //     .getOne('media', 'file', 'img-$id')
    //     .then((doc) => link = doc['base64']);
    // }
    if(imgStamp.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'song', id:id, imgStamp:imgStamp);
    }
    else if(album != null && imgStamp_album.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'album', id:album?.id, imgStamp:imgStamp_album);
    }
    else if(artist != null && imgStamp_artist.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'artist', id:artist?.id, imgStamp:imgStamp_artist);
    }
    else {
      link = Injector.get<ContentProvider>()
        .getImage(database:'media', type:'song', id:id, imgStamp:imgStamp);
    }

    thumbnail = link;
  }

  Future<String> getStreamLink(String version) async
  {
    String cBitrate;
    bool isOrginal = false;
    String link;

    // if local exist
    // if(isLocal)
    // {
    //   await Injector.get<IndexedDBService>()
    //     .getOne('media', 'file', 'song-$id')
    //     .then((doc) {
    //       if(doc != null) link = doc['base64'];
    //     });
    // }
    //get online link
    // else
    // {
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
      link = Uri.https(Vars.mainHost, 'stream', 
        {'ai': artist?.id, 'si': id, 'br': cBitrate, 'org': isOrginal.toString()})
        .toString();
    // }
    
    return link;
  }

  String getDownloadLink(String version)
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
    Uri link = Uri.https(Vars.mainHost, 'stream/downloadsong', 
      {'ai': artist.id, 'si': id, 'br': cBitrate, 'org': isOrginal.toString()});

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
  String get link => '#${Injector.get<PageRoutes>().getRouterUrl('song', {'id': id})}';
  String get link_album => album?.link; //'#${Injector.get<PageRoutes>().getRouterUrl('album', {'id': albumId})}';
  String get link_artist => artist?.link; //'#${Injector.get<PageRoutes>().getRouterUrl('artist', {'id': artistId})}';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    if(T == Card)
    {
      widget = Card( 
        title,
        subtitle: artist?.name ?? '',
        subtitleLink: link_artist,
        id: id,
        thumbnail: thumbnail,
        type: ArchiveTypes.song,
        origin: this,
        localTitle: localTitle,
        localTitle_sub: artist?.localTitle,
      ) as T;
    }

    else if(T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(
        title,
        subtitle: artist?.name ?? '',
        id: id,
        duration: getDuration(),
        number: digititemNumber,
        thumbnail: thumbnail,
        type: ArchiveTypes.song,
        origin: this,
        localTitle: localTitle,
        localTitle_sub: artist?.localTitle,
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

    if(userService.isLogedIn)
      isLiked = await userService.user.traker.getLikeStatus(id, type: type);
    
    return isLiked;
  }

  @override
  Future<bool> like() async
  {
    isLiked = !isLiked;

    // return isLiked;
    UserService userService = Injector.get<UserService>();

    if(!userService.isLogedIn) return false;

    isLiked = await userService.user.traker.reportLikedSong(this);

    return isLiked;
  }

  String getLocalTitle()
  {
    String languageCode = Injector.get<LanguageService>().getCode();
    String tempTitle = title;

    if( localTitle != null &&
        localTitle.containsKey(languageCode) && 
        localTitle[languageCode].length > 0)
      tempTitle = localTitle[languageCode];

    return tempTitle;
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

  Future<bool> getDownloadedStatus() 
  {
    return Injector.get<IndexedDBService>().getOne('media', 'song', id)
      .then((doc) => doc != null ? true : false);
  }
}
/// {@nodoc}
library album;

import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

import 'song.dart';
import 'media_item.dart';

class Album implements MediaItem
{
  String id;
  String artistId;
  ArchiveTypes type;

  ResultWithNavigator<Song> songNavigator;

  String title;
  String artist;
  String description;
  String thumbnail;
  String imgStamp;
  String imgStamp_artist;

  Map localTitle;

  Album({this.id, this.artistId, this.type, this.title, this.artist, 
    this.description, this.imgStamp, this.imgStamp_artist, 
    this.thumbnail, this.localTitle, bool dontGetSongs=false})
  {
    if(!dontGetSongs) getSongs();

    // get thumbnail link
    getThumbnailLink();
  }

  factory Album.fromjson(Map detail, {bool dontGetSongs=true})
  {
    Album album;
    try {
      album = Album(
        dontGetSongs: dontGetSongs,
        type        : ArchiveTypes.album,
        id          : (detail['_id'] != null)         ? detail['_id'].toString() : '',
        artistId    : (detail['artistId'] != null)    ? detail['artistId'] : '',
        title       : (detail['title'] != null)       ? detail['title'] : '',
        artist      : (detail['artist'] != null)      ? detail['artist'] : '',
        description : (detail['description'] != null) ? detail['description'] : '',
        imgStamp    : (detail['imgStamp']   != null)  ? detail['imgStamp'] : '',
        imgStamp_artist    : (detail['imgStamp_artist']   != null)  ? detail['imgStamp_artist'] : '',
        localTitle: (detail['local_title'] != null) ? detail['local_title'] : {},
      );
    } 
    catch (e) {
      print('convert album from json $detail');
      print(e);
    }

    return album;
  }

  void getThumbnailLink()
  {
    String link;

    if(imgStamp.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'album', id:id, imgStamp:imgStamp);
    }
    else if(imgStamp_artist.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'artist', id:artistId, imgStamp:imgStamp_artist);
    }

    thumbnail = link;
  }

  void getSongs() async
  {
    ContentProvider cp = Injector.get<ContentProvider>();
    songNavigator = await cp.mediaselector.song_getListByAlbum(id);
    //injectAlbumCover();
  }

  // void injectAlbumCover()
  // {
  //   songNavigator.list.forEach((song) 
  //   {
  //       if(song.thumbnail == null || song.thumbnail?.length == 0)
  //         song.thumbnail = thumbnail;
  //   });
  // }

  dynamic toDynamic()
  {
    return {
      'title'   : title,
      'artist' : artist,
      'description' : description,
      'thumbnail'   : thumbnail,
    };
  }

  @override
  String get link => '#${Injector.get<PageRoutes>().getRouterUrl('album', {'id': id})}';
  String get link_artist => "#${Injector.get<PageRoutes>().getRouterUrl('artist', {'id': artistId})}";

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
        thumbnail: thumbnail,
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
        subtitleLink: link_artist,
        localTitle: localTitle,
      ) as T;
    }
    else if (T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(
        artist,
        subtitle: title,
        id: id,
        duration: '',
        number: digititemNumber,
        thumbnail: thumbnail,
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
        localTitle: localTitle,
      ) as T;
    }

    return widget;
  }

  @override
  List<T> getChildsAsWidgets<T>({int total = 1})
  {
    List<T> items = [];

    for(int i=0; i < total; i++)
    {
      Song item = songNavigator.list[i];
      String itemNumber = getDigitStyle(i+1, 2);

      T widget;

      if(T == Card)
      {
        widget = Card<Song>( 
          item.title,
          subtitle: item.artist,
          id: item.id,
          thumbnail: item.thumbnail,
          type: ArchiveTypes.media,
          origin: item,
          localTitle: item.localTitle,
        ) as T;
      }
      else if (T == ListItem)
      {
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
  bool isLiked = false;
  bool isLocal = false;
}
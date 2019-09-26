/// {@nodoc}
library album;

import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

import 'song.dart';
import 'artist.dart';
import 'media_item.dart';

class Album implements MediaItem
{
  String id;
  //String artistId;
  ArchiveTypes type;

  ResultWithNavigator<Song> songNavigator;

  String title;
  Artist artist;
  String description;
  String thumbnail;
  String imgStamp;
  String imgStamp_artist;

  Map localTitle;

  Album({
    this.id, 
    // this.artistId, 
    this.type, 
    this.title, 
    this.artist, 
    this.description, 
    this.imgStamp='', 
    this.imgStamp_artist='', 
    this.thumbnail, 
    this.localTitle, 
    bool dontGetSongs=false})
  {
    if(!dontGetSongs) getSongs();

    // get thumbnail link
    getThumbnailLink();
  }

  factory Album.fromjson(Map detail, {Artist artist, bool dontGetSongs=true})
  {
    Album album;
    try {
      album = Album(
        dontGetSongs: dontGetSongs,
        type        : ArchiveTypes.album,
        id          : detail['_id'],
        title       : detail['title'],
        // artistId    : detail['artistId'],
        artist      : artist,
        description : detail['description'],
        imgStamp    : detail['imgStamp'],
        localTitle  : detail['local_title'],
        imgStamp_artist    : detail['imgStamp_artist'],
      );
    } 
    catch (e) {
      print(e);
      print('convert album from json $detail');
    }

    return album;
  }

  factory Album.fromPopulatedDoc(Map detail, {bool dontGetSongs=true})
  {
    Album album;

    try{

      Artist artist = Artist.fromjson(detail['artistId']);
      album = Album.fromjson(detail, artist: artist, dontGetSongs: dontGetSongs);

      }catch(e){
        print(e);
        print('convert album fromPopulatedDoc $detail');
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
    else if(artist != null && imgStamp_artist.length > 10)
    {
     link = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'artist', id:artist.id, imgStamp:imgStamp_artist);
    }
    else {
      link = Injector.get<ContentProvider>()
        .getImage(database:'media', type:'album', id:id, imgStamp:imgStamp);
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
  String get link_artist => artist.link; //"#${Injector.get<PageRoutes>().getRouterUrl('artist', {'id': artist.id})}";

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    if(T == Card)
    {
      widget = Card(
        title,
        subtitle: artist.name,
        id: id,
        thumbnail: thumbnail,
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
        subtitleLink: link_artist,
        localTitle: localTitle,
        localTitle_sub: artist.localTitle,
      ) as T;
    }
    else if (T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(
        title,
        subtitle: artist.name,
        id: id,
        duration: '',
        number: digititemNumber,
        thumbnail: thumbnail,
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
        localTitle: localTitle,
        localTitle_sub: artist.localTitle,
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
          subtitle: item.artist.name,
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
          subtitle: item.artist.name,
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

  String getLocalTitle()
  {
    String languageCode = Injector.get<LanguageService>().getCode();
    String tempTitle = title;

    if(localTitle.containsKey(languageCode) && localTitle[languageCode].length > 0)
      tempTitle = localTitle[languageCode];

    return tempTitle;
  }

  @override
  bool isLiked = false;
  bool isLocal = false;
}
import 'package:melodyku/src/class/archive/media_item.dart';
import 'dart:async';

import '../injector.dart' as CI;
import '../../services/content_provider/content_provider.dart';
import '../../routting/routes.dart';

import '../classes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Album implements SongItem
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

  Album({this.id, this.artistId, this.type, this.title, this.artist, 
    this.description, this.imgStamp, this.thumbnail, bool dontGetSongs=false})
  {
    if(!dontGetSongs) getSongs();
  }

  factory Album.fromjson(Map detail, {bool dontGetSongs})
  {
    Album album;
    try {

      List<Song> items = [];

      if(detail.containsKey('songs'))
      {
        detail['songs'].forEach((item) 
        { items.add(Song.fromjson(item)); });
      }
      
      album = Album(
        dontGetSongs: dontGetSongs,
        type        : ArchiveTypes.album,
        id          : (detail['_id'] != null)         ? detail['_id'].toString() : '',
        artistId    : (detail['artistId'] != null)    ? detail['artistId'] : '',
        title       : (detail['title'] != null)       ? detail['title'] : '',
        artist      : (detail['artist'] != null)      ? detail['artist'] : '',
        description : (detail['description'] != null) ? detail['description'] : '',
        imgStamp    : (detail['imgStamp']   != null)  ? detail['imgStamp'] : '',
        thumbnail   : (detail['thumbnail'] != null)   ? detail['thumbnail'] : getRandomCovers(1)[0],
      );
    } 
    catch (e) {
      print('convert album from json $detail');
      print(e);
    }

    return album;
  }

  void getSongs() async
  {
    ContentProvider cp = CI.Injector.get<ContentProvider>();
    songNavigator = await cp.stitchArchive.song_getListByAlbum(id);
  }

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
  String get link => '/#album/$id';

  @override
  T getAsWidget<T>({int itemNumber=1})
  {
    T widget;

    Map<String, String> params = {'id':id.toString()};
    String link = '#${CI.Injector.get<PageRoutes>().getRouterUrl('album', params)}';

    if(T == Card)
    {
      widget = Card(
        artist,
        subtitle: title,
        id: id,
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
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
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.album,
        origin: this,
        titleLink: link,
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
      item.thumbnail = getRandomCovers(1)[0];
      String itemNumber = getDigitStyle(i+1, 2);

      T widget;

      if(T == Card)
      {
        widget = Card<Song>( 
          item.title,
          subtitle: item.artist,
          id: item.id,
          thumbnail: Uri(path: item.thumbnail),
          type: ArchiveTypes.media,
          origin: item
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
  bool isLiked;
}
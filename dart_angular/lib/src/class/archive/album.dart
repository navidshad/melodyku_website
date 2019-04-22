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

  List<Song> list;

  String name;
  String artist;
  String description;
  String thumbnail;

  Album({this.id, this.artistId, this.type, this.name, this.artist, 
    this.list, this.description, this.thumbnail})
  {
    if(list.length == 0) getSongs();
  }

  factory Album.fromjson(Map detail)
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
        type        : ArchiveTypes.album,
        id          : (detail['_id'] != null)         ? detail['_id'] : '',
        artistId    : (detail['artistId'] != null)    ? detail['artistId'] : '',
        name        : (detail['name'] != null)        ? detail['name'] : '',
        artist      : (detail['artist'] != null)      ? detail['artist'] : '',
        description : (detail['description'] != null) ? detail['description'] : '',
        thumbnail   : (detail['thumbnail'] != null)   ? detail['thumbnail'] : getRandomCovers(1)[0],
        list        : items,
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
    print('album getSongs');
    ContentProvider cp = CI.Injector.get<ContentProvider>();
    ResultWithNavigator<Song> rwn = await cp.stitchArchive.song_getListByAlbum(id);
    list = rwn.list;
  }

  dynamic toDynamic()
  {
    return {
      'name'   : name,
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

    print('id $id');
    print('origin $this');
    print('subtitle $id');
    print('titleLink $artist');
    print('titleLink $link');

    if(T == Card)
    {
      widget = Card( name,
        id: id,
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.album,
        origin: this,
        subtitle: artist,
        titleLink: link,
      ) as T;
    }
    else if (T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(name,
        id: id,
        duration: '',
        number: digititemNumber,
        thumbnail: Uri(path: thumbnail),
        type: ArchiveTypes.album,
        origin: this,
        subtitle: artist,
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
      Song item = list[i];
      item.thumbnail = getRandomCovers(1)[0];
      String itemNumber = getDigitStyle(i+1, 2);

      T widget;

      if(T == Card)
      {
        widget = Card<Song>( item.title,
            id: item.id,
            thumbnail: Uri(path: item.thumbnail),
            type: ArchiveTypes.media,
            origin: item
        ) as T;
      }
      else if (T == ListItem)
      {
        widget = ListItem<Song>(item.title,
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
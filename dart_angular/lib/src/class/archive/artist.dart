import 'package:melodyku/src/class/archive/media_item.dart';
import 'dart:async';

import '../classes.dart';

import '../injector.dart' as CI;
import '../../routting/routes.dart';

import 'media_item.dart';
import '../types.dart';
import '../widgets/card.dart';
import '../widgets/list_item.dart';

class Artist implements SongItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked;

  String name;
  String description;
  String thumbnail;
  String imgStamp;

  Artist({this.id, this.name, this.description, this.imgStamp, this.thumbnail});

  factory Artist.fromjson(dynamic detail)
  {
    Artist artist;
    try {
      artist =  Artist(
        id        : (detail['_id'] != null) ? detail['_id'].toString() : '',
        name      : (detail['name'] != null) ? detail['name'] : '',
        description: (detail['description'] != null) ? detail['description'] : '',
        imgStamp  : (detail['imgStamp'] != null) ? detail['imgStamp'] : '',
        thumbnail : (detail['thumbnail'] != null) ? detail['thumbnail'] : getRandomCovers(1)[0],
        );
    } 
    catch (e) {
      print('convert artist from json $detail');
      print(e);
    }
    return artist;
  }

  dynamic toDynamic()
  {
    return {
      'name'        : name,
      'description' : description,
      'thumbnail'   : thumbnail
    };
  }

  @override
  String get link => '/#artist/$id';

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

  @override
  T getAsWidget<T>({int itemNumber=1}) {
    T widget;

    Map<String, String> params = {'id':id.toString()};
    String link = '#${CI.Injector.get<PageRoutes>().getRouterUrl('artist', params)}';

    if(T == Card)
    {
      widget = Card( 
        name,
        id: id,
        thumbnail: Uri(path: this.thumbnail),
        titleLink: link,
        type: ArchiveTypes.artist,
        origin: this
      ) as T;
    }
    else if (T == ListItem)
    {
      String digititemNumber = getDigitStyle(itemNumber+1, 2);
      widget = ListItem(
        name,
        id: id,
        duration: '',
        number: digititemNumber,
        thumbnail: Uri(path: this.thumbnail),
        titleLink: link,
        type: ArchiveTypes.artist,
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
}
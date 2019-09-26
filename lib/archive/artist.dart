/// {@nodoc}
library artist;

import 'dart:async';

import 'media_item.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

class Artist implements MediaItem
{
  dynamic id;
  ArchiveTypes type;
  bool isLiked = false;
  bool isLocal = false;

  String name;
  String description;
  String thumbnail;
  String imgStamp;

  Map localTitle;

  Artist({this.id, this.name, this.description, 
    this.imgStamp, this.thumbnail, this.localTitle})
  {
    // get thumbnail link
    thumbnail = Injector.get<ContentProvider>()
      .getImage(database:'media', type:'artist', id:id, imgStamp:imgStamp);
  }

  factory Artist.fromjson(dynamic detail)
  {
    Artist artist;
    try {
      artist =  Artist(
        id        : (detail['_id'] != null) ? detail['_id'].toString() : '',
        name      : (detail['name'] != null) ? detail['name'] : '',
        description: (detail['description'] != null) ? detail['description'] : '',
        imgStamp  : (detail['imgStamp'] != null) ? detail['imgStamp'] : '',
        localTitle: (detail['local_title'] != null) ? detail['local_title'] : {},
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
  String get link => '#${Injector.get<PageRoutes>().getRouterUrl('artist', {'id': id})}';

  String getLocalTitle()
  {
    String languageCode = Injector.get<LanguageService>().getCode();
    String tempTitle = name;

    if(localTitle.containsKey(languageCode) && localTitle[languageCode].length > 0)
      tempTitle = localTitle[languageCode];

    return tempTitle;
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
  T getAsWidget<T>({int itemNumber=1}) {
    T widget;

    if(T == Card)
    {
      widget = Card( 
        name,
        id: id,
        thumbnail: thumbnail,
        titleLink: link,
        type: ArchiveTypes.artist,
        origin: this,
        localTitle: localTitle,
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
        thumbnail: thumbnail,
        titleLink: link,
        type: ArchiveTypes.artist,
        origin: this,
        localTitle: localTitle,
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
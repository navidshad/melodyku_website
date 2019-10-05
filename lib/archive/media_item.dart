/// {@nodoc}
library mediaItem;

import 'package:melodyku/core/types.dart';

abstract class MediaItem
{
  final dynamic id;
  final ArchiveTypes type;
  
  bool isLiked = false;
  bool isLocal = false;

  MediaItem(this.id, this.type)
  {
    //getLikeStatus();
  }

  like() {}

  getLikeStatus() {}

  String getLocalTitle() {}
  
  String get link;

  String thumbnail;

  Map getAsMap();

  getAsWidget<T>() {}

  getChildsAsWidgets<T>() {}
}
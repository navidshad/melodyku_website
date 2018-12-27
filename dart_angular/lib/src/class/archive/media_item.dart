import '../types.dart';

abstract class MediaItem
{
  final dynamic id;
  final ArchiveTypes type;
  bool isLiked = false;

  MediaItem(this.id, this.type)
  {
    //getLikeStatus();
  }

  Future<bool> like() {}

  Future<bool> getLikeStatus() {}

  Future<bool> getPlayStatus() {}

  void play() {}

  T getAsWidget<T>() {}

  List<T> getChildsAsWidgets<T>() {}
}
import '../types.dart';

abstract class MediaItem
{
  final dynamic id;
  final ArchiveTypes type;

  MediaItem(this.id, this.type);

  Future<bool> like() {}

  Future<bool> getLikeStatus() {}

  Future<bool> getPlayStatus() {}

  void play() {}

  T getAsWidget<T>() {}

  List<T> getChildsAsWidgets<T>() {}
}
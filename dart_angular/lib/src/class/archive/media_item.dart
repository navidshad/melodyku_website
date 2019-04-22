import '../types.dart';
import 'dart:async';

abstract class SongItem
{
  final dynamic id;
  final ArchiveTypes type;
  bool isLiked = false;

  SongItem(this.id, this.type)
  {
    //getLikeStatus();
  }

  Future<bool> like() {}

  Future<bool> getLikeStatus() {}

  Future<bool> getPlayStatus() {}
  
  String get link;

  String thumbnail;

  void play() {}

  T getAsWidget<T>() {}

  List<T> getChildsAsWidgets<T>() {}
}
import 'media.dart';

class Playlist {
  String title;
  List<Media> list;

  Playlist({this.title, this.list});

  factory Playlist.fromjson(dynamic detail)
  {
    try {
      List<Media> items = (detail['list'] as List)
      .map((item) => Media.fromjson(item) ).toList();
      return Playlist( title: detail['name'], list: items );
    } 
    catch (e) {
      print('convert playlist from json');
      print(e);
    }
  }
}

class PlayListItem {
  String title;
  String singer;

  PlayListItem(this.title, this.singer);
}
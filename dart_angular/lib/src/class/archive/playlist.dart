import '../classes.dart';


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

  // methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);
}
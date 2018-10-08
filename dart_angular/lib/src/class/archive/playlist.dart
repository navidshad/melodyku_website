import '../classes.dart';


class Playlist {
  String title;
  List<Media> list;
  String thumbnail;

  Playlist({this.title, this.list, this.thumbnail});

  factory Playlist.fromjson(dynamic detail)
  {
    try {
      List<Media> items = (detail['list'] as List)
      .map((item) => Media.fromjson(item) ).toList();
      return Playlist( title: detail['name'], thumbnail: detail['thumbnail'], list: items );
    } 
    catch (e) {
      print('convert playlist from json');
      print(e);
    }
  }

  dynamic toDynamic()
  {
    return {
      'name': title, 
      'thumbnail': thumbnail, 
      'list': list.map((media){media.toDynamic();})
      };
  }

  String getDuration()
  {
    int length = 0;
    list.forEach((media){ length += media.duration; });

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    String durationStr;
    if(hours > 0) durationStr += '$hours : ';
    durationStr += '$minutes : $seconds';

    return durationStr;
  }

  // methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);
}
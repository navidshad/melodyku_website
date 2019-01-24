import '../classes.dart';

class Result_Album extends ListResult
{
  List<Album> list;

  Result_Album(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Album
  .fromjson(int pages, int current, dynamic items)
  {
    List<Album> albums = [];
    items.forEach((item) 
      => albums.add(Album.fromjson(item)));

    return Result_Album(
      pages, 
      current,
      albums
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.album, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.album, (total !=null) ? total: null);
}
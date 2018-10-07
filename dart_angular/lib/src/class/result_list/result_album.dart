import '../classes.dart';

class Result_Album extends ListResult
{
  List<Album> list;

  Result_Album(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Album
  .fromjson(int pages, int current, dynamic items){
    return Result_Album(
      pages, 
      current,
      items.map((item) => Album.fromjson(item))
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.album, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.album, (total !=null) ? total: null);
}
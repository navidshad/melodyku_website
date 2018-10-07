import '../classes.dart';

class Result_Media extends ListResult
{
  List<Media> list;

  Result_Media(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Media
  .fromjson(int pages, int current, dynamic items){
    return Result_Media(
      pages, 
      current,
      items.map((item) => Media.fromjson(item))
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);
}
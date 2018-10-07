import '../classes.dart';

class Result_Singer extends ListResult
{
  List<Singer> list;

  // constructor
  Result_Singer(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Singer
  .fromjson(int pages, int current, dynamic items){
    return Result_Singer(
      pages, 
      current,
      items.map((item) => Singer.fromjson(item))
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.singer, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.singer, (total !=null) ? total: null);
}
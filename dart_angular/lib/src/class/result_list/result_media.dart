import '../classes.dart';

class Result_Media extends ListResult
{
  List<Media> list;

  Result_Media(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Media
  .fromjson(int pages, int current, dynamic items)
  {
    List<Media> medias = [];
    items.forEach((item) 
      => medias.add(Media.fromjson(item))
    );

    return Result_Media(
      pages, 
      current,
      medias
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);
}
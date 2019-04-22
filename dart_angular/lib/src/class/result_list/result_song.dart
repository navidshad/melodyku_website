import '../classes.dart';

class Result_Song extends ListResult
{
  List<Song> list;

  Result_Song(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Song
  .fromjson(int pages, int current, dynamic items)
  {
    List<Song> medias = [];
    items.forEach((item) 
      => medias.add(Song.fromjson(item))
    );

    return Result_Song(
      pages, 
      current,
      medias
      );
  }

  // abstract methods
  // List<Card> getCardList([int total]) =>
  //   ArchiveToWidget.toCards(list, ArchiveTypes.media, (total !=null) ? total: null);

  // List<ListItem> getItemList([int total]) =>
  //   ArchiveToWidget.toItemList(list, ArchiveTypes.media, (total !=null) ? total: null);
}
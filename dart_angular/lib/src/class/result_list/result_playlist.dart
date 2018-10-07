import '../classes.dart';

class Result_Playlist extends ListResult 
{
  List<Playlist> list;

  Result_Playlist(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Playlist
  .fromjson(int pages, int current, dynamic items){
    return Result_Playlist(
      pages, 
      current,
      items.map((item) => Playlist.fromjson(item))
      );
  }

  // abstract methods
  List<Card> getCardList([int total]) =>
    ArchiveToWidget.toCards(list, ArchiveTypes.playlist, (total !=null) ? total: null);

  List<ListItem> getItemList([int total]) =>
    ArchiveToWidget.toItemList(list, ArchiveTypes.playlist, (total !=null) ? total: null);
}
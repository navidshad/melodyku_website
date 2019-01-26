import '../classes.dart';

class Result_Playlist extends ListResult 
{
  List<Playlist> list;

  Result_Playlist(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Playlist
  .fromjson(int pages, int current, dynamic items)
  {
    List<Playlist> playlists = [];

    items.forEach((item) 
    {
      Playlist newList = Playlist.fromjson(item);
      playlists.add(newList);
    });

    return Result_Playlist(
      pages, 
      current,
      playlists
      );
  }
}
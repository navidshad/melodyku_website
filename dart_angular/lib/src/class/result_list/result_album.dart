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
}
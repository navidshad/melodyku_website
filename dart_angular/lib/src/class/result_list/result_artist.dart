import '../classes.dart';

class Result_Artist extends ListResult
{
  List<Artist> list;

  // constructor
  Result_Artist(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Artist
  .fromjson(int pages, int current, dynamic items)
  {
    List<Artist> artists = [];
    items.forEach((item) 
      => artists.add(Artist.fromjson(item)));

    return Result_Artist(
      pages, 
      current,
      artists,
      );
  }
}
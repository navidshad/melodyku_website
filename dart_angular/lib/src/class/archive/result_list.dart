import '../classes.dart';

class ListResult {
  int pages;
  int current;

  ListResult(this.pages, this.current);
}

class Result_SingerList extends ListResult 
{
  List<Singer> list;

  Result_SingerList(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_SingerList
  .fromjson(int pages, int current, dynamic items){
    return Result_SingerList(
      pages, 
      current,
      items.map((item) => Singer.fromjson(item))
      );
  }
}

class Result_AlbumList extends ListResult
{
  List<Album> list;

  Result_AlbumList(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_AlbumList
  .fromjson(int pages, int current, dynamic items){
    return Result_AlbumList(
      pages, 
      current,
      items.map((item) => Album.fromjson(item))
      );
  }
}

class Result_MediaList extends ListResult
{
  List<Media> list;

  Result_MediaList(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_MediaList
  .fromjson(int pages, int current, dynamic items){
    return Result_MediaList(
      pages, 
      current,
      items.map((item) => Media.fromjson(item))
      );
  }
}

class Result_PlaylistList extends ListResult 
{
  List<Playlist> list;

  Result_PlaylistList(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_PlaylistList
  .fromjson(int pages, int current, dynamic items){
    return Result_PlaylistList(
      pages, 
      current,
      items.map((item) => Playlist.fromjson(item))
      );
  }
}
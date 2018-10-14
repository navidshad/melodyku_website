import 'dart:convert';

class Media {
  String title;
  String singer;
  String album;
  List<String> genre;
  String lyric;
  String thumbnail;

  int year;
  int duration;

  Media({
    this.title, 
    this.singer, 
    this.album, 
    this.year, 
    this.genre,
    this.lyric,
    this.duration,
    this.thumbnail,
  });

  factory Media.fromjson(dynamic detail)
  {
    List<String> genre_list = (detail['genre'] as List).map((gn) => gn.toString()).toList();
    Media mFromJson;
    try {
      mFromJson = Media(
      title: (detail['title'] != null) ? detail['title'] : '',
      singer: (detail['albumartist'] != null) ? detail['albumartist'] : '',
      album: (detail['album'] != null) ? detail['album'] : '',
      genre: (detail['genre'] != null) ? genre_list : '',
      lyric: (detail['lyric'] != null) ? detail['lyric'] : '',
      year: (detail['year']   != null) ? detail['year'] : null,
      duration: (detail['duration']   != null) ? detail['duration'] : 0,
      thumbnail: (detail['thumbnail']   != null) ? detail['thumbnail'] : '',
    );

    if(detail['titleIndex'] != null) mFromJson.title = (detail['titleIndex']['ku_fa']).toString().trim();

    } catch (e) {
      print('convert Media from json ${json.encode(detail)}');
      print(e);
    }

    return mFromJson;
  }

  dynamic toDynamic()
  {
    return {
      'title'       : title,
      'albumartist' : singer,
      'album'       : album,
      'year'        : year,
      'genre'       : genre,
      'lyric'       : lyric,
      'duration'    : duration,
      'thumbnail'   : thumbnail,
    };
  }

  String getDuration([num customLength])
  {
    int length = 0;
    if(customLength != null && !customLength.isNaN) length = customLength.toInt();
    else if(duration != null) length = duration;

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    String durationStr = '';
    if(hours > 0) durationStr += '$hours : ';
    durationStr += '$minutes : $seconds';

    return durationStr;
  }
}
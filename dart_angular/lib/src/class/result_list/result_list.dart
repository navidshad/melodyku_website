import '../classes.dart';
export './result_album.dart';
export './result_song.dart';
export './result_playlist.dart';
export './result_artist.dart';

export './archive_to_widget.dart';

abstract class ListResult {
  int pages;
  int current;

  ListResult(this.pages, this.current);
}




import 'song.dart';
import 'playlist.dart';
import 'package:melodyku/core/core.dart';

class UserPlaylist extends Playlist {
  String refId;

  UserPlaylist({
    this.refId,
    String id = '',
    String title,
    List<Song> list = const [],
    String thumbnail,
    String imgStamp = '',
    Map localTitle,
    bool limitMode,
    int limitation,
  }) : super(
          id: id,
          title: title,
          list: list,
          thumbnail: thumbnail,
          imgStamp: imgStamp,
          localTitle: localTitle,
          limitMode: limitMode,
          limitation: limitation,
        );

  factory UserPlaylist.fromjson(Map detail, {bool listContainsObject=true})
  {
    UserPlaylist playlist;
    try {
      List<Song> items = [];

      if(detail.containsKey('list') && listContainsObject)
      {
        List songMaps = detail['list'];

        songMaps.forEach((item) { 
          Song newSong = Song.fromPopulatedDoc(item);
          items.add(newSong); 
        });
      }

      playlist = UserPlaylist( 
        id        : detail['_id'], 
        refId     : detail['refId'],
        title     : detail['title'], 
        imgStamp  : detail['imgStamp'],
        localTitle: detail['local_title'],
        list      : items.reversed.toList(),
        limitMode : detail['limitMode'],
        limitation: detail['limitation']
      );
    } 
    catch (e) {
      print('convert userPlaylist from json');
      print('$e | $detail[]');
    }
    return playlist;
  }

  @override
  String get link => '#${Injector.get<PageRoutes>().getRouterUrl("user-playlist", {"id": id})}';

  Map getAsMap()
  {
    return {
      '_id'       : id,
      'refId'     : refId,
      'title'     : title, 
      'imgStamp'  : imgStamp, 
      'categories': categories,
      'localTitle': localTitle,
      'limitMode' : limitMode,
      'limitation': limitation,
      'list'      : list.map((media) => media.id),
      };
  }
}

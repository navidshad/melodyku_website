/// {@nodoc}
library playerService;

import 'package:melodyku/core/widgets/player.dart';
import 'package:melodyku/archive/archive.dart';

class PlayerService 
{
 	Player _player;

  PlayerService(this._player)
  {

  }

  void play(Song song)  => _player.playByTrack(song);
  void playByList(List<Song> list) => _player.playByList(list);

  void playByMap(Map doc)
  {
  	Song song = Song.fromjson(doc);
  	play(song);
  }
}
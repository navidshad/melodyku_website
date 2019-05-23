import 'package:melodyku/src/class/classes.dart';

class PlayerService 
{
 	Player _player;

  PlayerService(this._player)
  {

  }

  void play(Song song)  => _player.playByTrack(song);
  void playByList(List<Song> list) => _player.playByList(list);
}
/// {@nodoc}
library playerService;

import 'package:melodyku/core/widgets/player.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';

class PlayerService 
{
 	Player _player;
  ContentProvider _provider;

  PlayerService(this._player, this._provider)
  {

  }

  void play(Song song)  => _player.playByTrack(song);
  void playByList(List<Song> list) => _player.playByList(list);

  void playByID(String id)
  {
    _provider.mediaselector.getItemByID<Song>(id)
      .then((s) => play(s as Song));

  	// Song song = Song.fromjson(doc);
  	// play(song);
  }

  void addToPlayingList(Song song)
    => _player.add(song);

  void addToPlayingList_ByList(List<Song> list)
  {
    list.forEach((s) => addToPlayingList(s));
  }
}
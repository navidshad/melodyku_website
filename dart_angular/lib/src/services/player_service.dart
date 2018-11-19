import 'dart:async';
import '../class/utility/stream_detail.dart';

export '../class/widgets/player.dart';

class PlayerService 
{
  Stream<StreamDetail_Player> modalStream;
  StreamController<StreamDetail_Player> _modalStreamController;

  PlayerService()
  {
    _modalStreamController = StreamController();
    modalStream = _modalStreamController.stream;
  }

  void play(StreamDetail_Player detail) =>
    _modalStreamController.add(detail);
}
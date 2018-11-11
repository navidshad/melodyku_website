import 'dart:async';
import '../class/classes.dart';

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
import 'dart:async';
import '../class/classes.dart';

class PlayerService 
{
  Stream<ModalPlayerDetail> modalStream;
  StreamController<ModalPlayerDetail> _modalStreamController;

  PlayerService()
  {
    _modalStreamController = StreamController();
    modalStream = _modalStreamController.stream;
  }

  void play(ModalPlayerDetail detail) =>
    _modalStreamController.add(detail);
}
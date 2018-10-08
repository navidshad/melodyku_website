import 'dart:async';
import '../class/classes.dart';

class ModalService 
{
  Stream<ModalPlayerDetail> modalPlayerStream;
  StreamController<ModalPlayerDetail> _modalPlayerStreamController;

  ModalService()
  {
    _modalPlayerStreamController = StreamController();
    modalPlayerStream = _modalPlayerStreamController.stream;
  }

  void play(ModalPlayerDetail detail) =>
    _modalPlayerStreamController.add(detail);
}
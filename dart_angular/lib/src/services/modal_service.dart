import 'dart:async';
import '../class/classes.dart';

class ModalService 
{
  Stream<ModalDetail> modalStream;
  StreamController<ModalDetail> _modalStreamController;

  ModalService()
  {
    _modalStreamController = StreamController();
    modalStream = _modalStreamController.stream;
  }

  void switchModal(ModalDetail detail) =>
    _modalStreamController.add(detail);
}
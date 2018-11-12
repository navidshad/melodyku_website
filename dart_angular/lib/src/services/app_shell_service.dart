import 'dart:async';
import '../class/classes.dart';

class AppShellService {
  Stream<StreamDetail_Common> displayableElementStream;
  StreamController<StreamDetail_Common> _displayableElementStreamController;

  AppShellService()
  {
    _displayableElementStreamController = StreamController();
    displayableElementStream = _displayableElementStreamController.stream;
  }

  void show(StreamDetail_Common event) {
    _displayableElementStreamController.add(event);
  }

}
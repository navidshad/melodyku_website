import '../classes.dart';

enum ModalType {player}

class ModalPlayerDetail {
  bool visible;
  ArchiveTypes type;
  dynamic object;

  ModalPlayerDetail(this.visible, this.type, this.object);
}
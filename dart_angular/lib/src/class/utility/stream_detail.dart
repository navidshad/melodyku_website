import '../classes.dart';
export '../types.dart';

class MessageDetail {
  bool visible;
  MessageType type;
  dynamic detail;
  
  MessageDetail({this.visible, this.type, this.detail});
}

class StreamDetail_Player {
  bool visible;
  ArchiveTypes type;
  dynamic object;

  StreamDetail_Player(this.visible, this.type, this.object);
}
import '../classes.dart';

class StreamDetail_Common {
  bool visible;
  StreamType type;
  //dynamic detail;
  
  StreamDetail_Common(this.visible, [this.type]);
}

class StreamDetail_Player {
  bool visible;
  ArchiveTypes type;
  dynamic object;

  StreamDetail_Player(this.visible, this.type, this.object);
}
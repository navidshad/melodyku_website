import 'dart:async';
import '../class/types.dart';
import '../class/utility/stream_detail.dart';

export '../class/utility/stream_detail.dart';

class MessageService 
{
  StreamController<MessageDetail> _messageController;

  MessageService()
  {
    _messageController = StreamController<MessageDetail>();
  }

  void send(MessageDetail message) =>
    _messageController.add(message);

  void addListener(fn) =>
    _messageController.stream.listen(fn);

}
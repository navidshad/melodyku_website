/// {@nodoc}
library messageService;

import 'dart:async';

import 'package:melodyku/core/utility/stream_detail.dart';
export 'package:melodyku/core/utility/stream_detail.dart';
export 'package:melodyku/core/types.dart';

class MessageService 
{
  StreamController<MessageDetail> _messageController;
  Stream<MessageDetail> _broadCast;
  List<dynamic> listeners = [];

  MessageService()
  {
    _messageController = StreamController<MessageDetail>();
    _broadCast = _messageController.stream.asBroadcastStream();
  }

  void send(MessageDetail message) 
  {
    print('send message to: ${message.type}, ${message.visible}, ${message.detail}');
    _messageController.add(message);
  }

  void addListener(String name, fn) 
  {
    print('addListener $name');
    // check if added already
    bool isAdded = false;
    for (var i = 0; i < listeners.length; i++)
      if(listeners[i]['name'] == name) 
      {
        isAdded = true;
        listeners[i]['fn'] = fn;
      }

    // add new listener
    if(!isAdded) _addNewListener(name, fn);
    // if added then cancell all listeners and add again
    else _reCreateListeners();
  }

  void _reCreateListeners()
  {
    // create new controller
    _messageController = StreamController<MessageDetail>();
    
    print('listeners.length ${listeners.length}');

    // add listeners
    for (var i = 0; i < listeners.length; i++){
      _broadCast.listen(listeners[i]['fn']);
      print('${listeners[i]['name']}');
    }
  }

  void _addNewListener(String name, fn)
  {
    try {

      dynamic listener = { 'name': name, 'fn': fn };
      listeners.add(listener);
      _broadCast.listen(fn);

    } catch (e) {
      print('$name, $e');
    }
  }
}
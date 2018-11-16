import 'dart:async';
import '../class/utility/stream_detail.dart';

export '../class/utility/stream_detail.dart';

class MessageService 
{
  StreamController<MessageDetail> _messageController;
  List<dynamic> listeners = [];

  MessageService()
  {
    _messageController = StreamController<MessageDetail>();
  }

  void send(MessageDetail message) =>
    _messageController.add(message);

  void addListener(String name, fn) 
  {
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
    
    // add listeners
    for (var i = 0; i < listeners.length; i++) 
      _messageController.stream.listen(listeners[i]['fn']);
  }

  void _addNewListener(String name, fn)
  {
    dynamic listener = { 'name': name, 'fn': fn };
    listeners.add(listener);
    _messageController.stream.listen(fn);
  }
}
/// {@nodoc}
library modalService;

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class ModalService 
{
  MessageService _messageService;
  Map<String, Modal> _modalList;

  // construction ===============================
  ModalService(this._messageService)
  {
    _modalList = Map<String, Modal>();
    _messageService.addListener('modalService', resiveMessage);
  }

  void resiveMessage(MessageDetail message) async
  {
    print('modal service recived a message');
    if(message.type != MessageType.modal) return;

    // get modal detail
    String name = message.detail['name'];
    bool showing = message.visible;

    // hide all
    await _hideAll(name);

    // show modal
    if(showing) show(name);
  }

  // methods ====================================
  void register(String name, Modal m) => 
    _modalList[name] = m;

  void show(String name) {
    _modalList[name].show();
    print('show modal $name by modal manager');
  }

  void _hideAll(String except) =>
    _modalList.forEach((String name, Modal modal) 
    {
      if(name != except) modal.close();
    });
}
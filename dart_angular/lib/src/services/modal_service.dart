import '../class/modal/modal.dart';
import '../services/message_service.dart';

export '../class/modal/modal.dart';

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
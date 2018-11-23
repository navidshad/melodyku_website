import 'dart:html';
import '../../services/user_service.dart';
import '../../services/message_service.dart';

class Page
{
  UserService _userService;

  PermissionType _permissionType;
  MessageService _messageService;
  bool _needLogedIn;
  String title;

  Page(this._userService, this._messageService, this._permissionType, this._needLogedIn, this.title)
  {
    checkAccess();
    updateTitleBar();
  }

  void checkAccess()
  {
    if(!_needLogedIn) return;

    bool isEquale = _userService.user.permission.hasAccess(_permissionType);
    if(!isEquale) window.location.pathname = "";
  }

  void updateTitleBar()
  {
    MessageDetail message = MessageDetail(type: MessageType.appshell, detail: {'title': title});
    _messageService.send(message);
  }
}
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/message_service.dart';

class Page
{
  UserService userService;

  PermissionType permissionType;
  MessageService messageService;
  bool needLogedIn;
  String title;

  Page({this.userService, this.messageService, this.permissionType, this.needLogedIn, this.title})
  {
    checkAccess();
    updateTitleBar();
  }

  void checkAccess()
  {
    if(!needLogedIn) return;

    bool isEquale = userService.user.hasAccess(permissionType);
    if(!isEquale) window.location.pathname = "";
  }

  void updateTitleBar()
  {
    MessageDetail message = MessageDetail(type: MessageType.appshell, detail: {'title': title});
    messageService.send(message);
  }
}
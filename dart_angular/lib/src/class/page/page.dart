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

    bool isEquale = false;

    try {
      userService.user.hasAccess(permissionType);
    }
    catch(e) {
      print("you don't have permission for this page, it will go to main page.");
    }
  
    if(!isEquale)
      window.location.replace('http://localhost:8080/');
  }

  void updateTitleBar()
  {
    MessageDetail message = MessageDetail(type: MessageType.appshell, detail: {'title': title});
    messageService.send(message);
  }
}
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/message_service.dart';

import 'package:melodyku/mongo_stitch/functions.dart';

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

    print('.: the $title page loaded :.');
  }

  void checkAccess()
  {
    if(!needLogedIn) return;

    bool hasAccess = false;

    try {
      hasAccess = userService.user.hasAccess(permissionType);
    }
    catch(e) {
      print("you don't have permission for this page, it will go to main page.");
    }
  
    if(!hasAccess) goToHome();
  }

  void updateTitleBar()
  {
    MessageDetail message = MessageDetail(type: MessageType.appshell, detail: {'title': title});
    messageService.send(message);
  }

  static void goToHome()
  {
    window.location.replace('/');
  }
}
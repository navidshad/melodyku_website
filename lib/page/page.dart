library page;

import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

export 'page_definition.dart';

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

    // track pageView
    Injector.get<AnalyticService>().trackPage(title);

    print('.: the $title page loaded :.');
  }

  void checkAccess() async
  {
    if(!needLogedIn) return;

    bool hasAccess = false;

    try {
      hasAccess = await userService.user.hasAccess(permissionType);
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
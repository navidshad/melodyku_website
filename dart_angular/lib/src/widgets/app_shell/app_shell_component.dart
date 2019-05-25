import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';
import 'dart:async';

import '../../class/injector.dart' as CI;

import '../../routting/routes.dart';
import '../../directives/ElementExtractorDirective.dart';
import '../../widgets/login_form_component/login_form_component.dart';
import '../../class/classes.dart';
import '../../services/services.dart';
import '../../services/message_service.dart';
import '../../class/utility/stream_detail.dart';
import '../../services/language_service.dart';
import '../../widgets/translate_btn_component/translate_btn_component.dart';


@Component(
  selector: 'app-shell',
  templateUrl: 'app_shell_component.html',
  styleUrls: [
    'app_shell_component.css',
    'drawer.css',
    'header.css',
    'profile.css',
  ],
  directives: [
    coreDirectives, 
    routerDirectives,
    ElementExtractorDirective,
    LoginFormComponent,
    TranslateBtnComponent,
    
  ],
  providers: [
    ClassProvider(PageRoutes),
  ],
)
class AppShellComponent
{
  LanguageService lang;
  PageRoutes pageRoutes;
  UserService _userService;
  StitchService _stitch;
  MessageService _messageService;
  bool isDrawerOpen = false;
  Drawer drawerMenu;
  Drawer drawerProfile;

  String _titleBar;
  get titleBar => lang.getStr(_titleBar);

  // constructor ================================
  AppShellComponent(this._stitch, this._userService, this._messageService, this.lang, this.pageRoutes)
  {
    CI.Injector.register(CI.InjectorMember('PageRoutes', pageRoutes));
    _messageService.addListener('appShell', resiveMessage);
  } 

  void resiveMessage(MessageDetail message)
  {
    if(message.type != MessageType.appshell) return;

    // check to get new title
    if(message.detail['title'] != null) 
      _titleBar = message.detail['title'];
  }

  // user =======================================
  bool get isLogedIn => _userService.isLogedIn;
  bool get isFirstLoggined => _stitch.user != null ? true : false;
  User get user => _userService.user;

  void logout() async 
  {
    await closeDrawers();
    _userService.logout();
    drawerProfile = null;
  }

  // register form ------------------------------
  void openlogin() => 
    _messageService.send(MessageDetail(visible: true, type: MessageType.modal, detail: {'name': 'login'}));


  // drawers ====================================
  void setupMenuDrawer(Element shell)
  {
    Element mainContent = shell.querySelector('#mainContent');
    Element planeEl = shell.querySelector('.drawer-plane');

    // main menu
    Element drawerMenuEl = shell.querySelector('#drawerMainMenu');
    Element drawerMenuBtnNoPushEl = shell.querySelector('.nopush');
    Element drawerMenuBtnPushEl = shell.querySelector('.push');

    drawerMenu = Drawer(
      drawerMenuEl, mainContent, 
      el_plane: planeEl,
      el_btn_noPushing: drawerMenuBtnNoPushEl, 
      el_btn_pushing: drawerMenuBtnPushEl,
      width: 80, 
      mainMargine: '80px', 
      direction: 'right', 
      planeOpacity: '0.8',
      openOnInitialied: true);
  }

  void setupProfileDrawer(Element shell)
  {
    Element mainContent = shell.querySelector('#mainContent');
    Element planeEl = shell.querySelector('.drawer-plane');

    // profile
    Element drawerProfileEl = shell.querySelector('#drawerProfile');
    Element drawerProfileBtnNoPush = shell.querySelector('.profile-btn');

    drawerProfile = Drawer(drawerProfileEl, mainContent, el_plane: planeEl,
      el_btn_noPushing: drawerProfileBtnNoPush,
      width: 250, mainMargine: '250px', direction: 'left', planeOpacity: '0.5');
  }

  Future<void> closeDrawers() async
  {
    drawerMenu.close();
    if(drawerProfile != null) drawerProfile.close();
    await Future.delayed(Duration(milliseconds: 500));
  }
}
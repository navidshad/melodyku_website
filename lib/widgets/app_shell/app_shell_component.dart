/// {@nodoc}
library appshellComponent;

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/pips/pips.dart';

//import 'package:melodyku/core/app_intaller.dart' as installer;
import 'package:melodyku/core/injector.dart' as CI;

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
    TranslateBtnComponent,
    DirectionDirective,
  ],
  pipes: [
    TitlePipe,
    UpFirstCharsPipe,
    UpperCasePipe,
   ],
  providers: [
    ClassProvider(PageRoutes),
  ],
)
class AppShellComponent
{
  AppshellService appshellService;
  LanguageService lang;
  PageRoutes pageRoutes;
  UserService _userService;
  MessageService _messageService;

  bool isDrawerOpen = false;
  Drawer drawerMenu;
  Drawer drawerProfile;

  String _titleBar;
  get titleBar => lang.getStr(_titleBar);

  List<MenuItem> mainMenuItems = [];
  List<MenuItem> profileItems = [];

  // constructor ================================
  AppShellComponent(this.appshellService, this._userService, this._messageService, this.lang, this.pageRoutes)
  {
    CI.Injector.register(InjectorMember('PageRoutes', pageRoutes));
    _messageService.addListener('appShell', resiveMessage);
    intialize();
  } 

  void resiveMessage(MessageDetail message)
  {
    if(message.type != MessageType.appshell) return;

    // check to get new title
    if(message.detail['title'] != null) 
      _titleBar = message.detail['title'];
  }

  // user =======================================
  bool _isReady = false;
  bool get isLogedIn => _userService.isLogedIn;
  bool get isFirstLoggined => _userService.user != null ? true : false;
  User get user => _userService.user;
  
  bool get allowLoadShell 
  {
    bool key  = false;

    if(!isLogedIn) key = true;
    else if(user != null && user.isLoadedData && lang.loaded)
      key = true;
    
    if(!_isReady) key = false;

    if(profileItems.length == 0)
      getMenuItems();
      
    return key;
  }

  void intialize() async
  {
    await lang.getLanguages();
    await CI.Injector.get<CategoryService>().getGroupsFromDb();
    await CI.Injector.get<CategoryService>().getCategoriesFromDb();

    getMenuItems();

    _isReady = true;
  }

  void getMenuItems()
  {
    mainMenuItems = pageRoutes.getMainMenuItems();
    profileItems  = pageRoutes.getProfileMenuItems();
  }

  void logout() async 
  {
    await closeDrawers();
    _userService.logout();
    drawerProfile = null;
    profileItems = [];
  }

  // register form ------------------------------
  void openlogin(String form) {
    //_messageService.send(MessageDetail(visible: true, type: MessageType.modal, detail: {'name': 'login'}));
    Navigator.gotTo('login', parameters: {'form':form});
  }

  void onPressSearch()
  {
    String path = window.location.href;
    if(path.contains('search')) Navigator.gotTo('vitrin');
    else Navigator.gotTo('search');
  }

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
      openOnInitialied: true
    );
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
      width: 250, mainMargine: '250px', direction: 'left');
  }

  Future<void> closeDrawers() async
  {
    drawerMenu.close();
    if(drawerProfile != null) drawerProfile.close();
    await Future.delayed(Duration(milliseconds: 500));
  }
}
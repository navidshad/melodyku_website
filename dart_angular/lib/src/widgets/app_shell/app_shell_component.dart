import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';

import '../../routting/routes.dart';
import '../../directives/ElementExtractorDirective.dart';
import '../../class/classes.dart';

@Component(
  selector: 'app-shell',
  templateUrl: 'app_shell_component.html',
  directives: [
    coreDirectives, 
    routerDirectives,
    ElementExtractorDirective,
  ],
  styleUrls: [
    'app_shell_component.scss.css',
    'drawer.scss.css',
    'header.scss.css',
  ],
  exports: [RoutePaths, Routes]
)
class AppShellComponent
{
  List<DrawerItem> drawerItems = menuItems;
  bool isDrawerOpen = false;
  Drawer drawerMenu;
  Drawer drawerProfile;

  void getElement(Element shell)
  {
    Element mainContent = shell.querySelector('#mainContent');
    Element planeEl = shell.querySelector('.drawer-plane');

    // main menu
    Element drawerMenuEl = shell.querySelector('#drawerMainMenu');
    Element drawerMenuBtnNoPushEl = shell.querySelector('.nopush');
    Element drawerMenuBtnPushEl = shell.querySelector('.push');

    drawerMenu = Drawer(drawerMenuEl, mainContent, el_plane: planeEl,
      el_btn_noPushing: drawerMenuBtnNoPushEl, el_btn_pushing: drawerMenuBtnPushEl,
      width: 80, mainMargine: '80px', direction: 'right', planeOpacity: '0.8');

    // profile
    Element drawerProfileEl = shell.querySelector('#drawerProfile');
    Element drawerProfileBtnNoPush = shell.querySelector('.profile-btn');

    drawerProfile = Drawer(drawerProfileEl, mainContent, el_plane: planeEl,
      el_btn_noPushing: drawerProfileBtnNoPush,
      width: 250, mainMargine: '250px', direction: 'left', planeOpacity: '0.5');
  }

  void closeDrawers()
  {
    drawerMenu.close();
    drawerProfile.close();
  }
}
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
  Element mainContent;

  void getElement(Element shell)
  {
    mainContent = shell.querySelector('#mainContent');
    Element drawerPlane = shell.querySelector('.drawer-plane');

    Element drawerMenuEl = shell.querySelector('.drawer');
    drawerMenu = Drawer(100, '100px', 'right', drawerMenuEl, mainContent);
  }

  void closeDrawers()
  {
    drawerMenu.doOpenClose(null, null);
  }
}
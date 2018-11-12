import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'dart:html';
import '../../routting/routes.dart';
import '../../directives/ElementExtractorDirective.dart';

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
  Element drawer;
  Element mainContent;

  void switchMenu()
  {
    String right = isDrawerOpen ? '-100px' : '0px';
    String margin = isDrawerOpen ? '0px' : '80px';

    drawer.style.right = right;
    mainContent.style.marginRight = margin;
    
    isDrawerOpen = !isDrawerOpen;
  }

  void getElement(Element el)
  {
    String type = el.attributes['id'];
    if(type == 'mainContent') mainContent = el;
    else if (type == 'drawer') drawer = el;
  }
}
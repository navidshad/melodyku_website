import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../routting/menu_items.dart';

@Component(
  selector: 'drawer-menu',
  templateUrl: 'drawer_menu.html',
  styleUrls: [
    'drawer_menu.scss.css'
  ],

  directives: const [
    coreDirectives,
    routerDirectives,
  ],
)
class DrawerMenu 
{
  List<DrawerItem> list = menuItems;
}
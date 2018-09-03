import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import 'menu_items.dart';

@Component(
  selector: 'drawer-menu',
  templateUrl: 'drawer_menu.html',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'drawer_menu.scss.css'
  ],

  directives: const [
    coreDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
)
class DrawerMenu 
{
  List<Item> list = items;

  @Input('menuDrawer')
  MaterialPersistentDrawerDirective drawer;
}
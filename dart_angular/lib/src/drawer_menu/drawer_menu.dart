import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';

@Component(
  selector: 'drawer-menu',
  template: 'drawer_menu.html',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'drawer_menu.scss.css'
  ],
  directives: [
    DeferredContentDirective,
    MaterialPersistentDrawerDirective
  ],
)
class DrawerMenu 
{

  DrawerMenu();
}
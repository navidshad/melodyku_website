import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';

@Component(
  selector: 'drawer-menu',
  templateUrl: 'drawer_menu.html',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'drawer_menu.scss.css'
  ],
  directives: [
    DeferredContentDirective,
  ],
)
class DrawerMenu 
{
  @Input('menuDrawer')
  MaterialPersistentDrawerDirective drawer;
}
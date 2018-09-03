import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_router/angular_router.dart';

import 'src/header_menu/header_menu.dart';
import 'src/drawer_menu/drawer_menu.dart';
import 'src/routting/routes.dart';

@Component(
  selector: 'my-app',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.scss.css'
  ],
  templateUrl: 'app_component.html',

  directives: [
    routerDirectives,
    MaterialPersistentDrawerDirective,
    DeferredContentDirective,
    DrawerMenu,
    HeaderMenu,
  ],
  exports: [RoutePaths, Routes]
)
class AppComponent 
{

}

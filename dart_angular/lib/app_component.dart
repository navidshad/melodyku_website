import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_router/angular_router.dart';

import 'src/app_layout/app_layout.dart';
import 'src/routting/routes.dart';

import 'src/services/services.dart';

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
    FooterComponent
  ],
  providers: [ ClassProvider(ContentProvider) ],
  exports: [RoutePaths, Routes]
)
class AppComponent 
{

}

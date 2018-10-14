import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'src/app_layout/app_layout.dart';
import 'src/widgets/widgets.dart';
import 'src/routting/routes.dart';

import 'src/services/services.dart';
import 'src/class/widgets/player.dart';

@Component(
  selector: 'my-app',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.scss.css'
  ],
  templateUrl: 'app_component.html',
  encapsulation: ViewEncapsulation.None,

  directives: [
    routerDirectives,
    MaterialPersistentDrawerDirective,
    DeferredContentDirective,
    DrawerMenu,
    HeaderMenu,
    FooterComponent,
    PlayerBareComponent,
  ],
  providers: const [ 
    materialProviders,
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    ClassProvider(Player),
    ],
  exports: [RoutePaths, Routes]
)
class AppComponent 
{

}

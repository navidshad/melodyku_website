import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'src/app_shell/app_shell.dart';
import 'src/widgets/widgets.dart';
import 'src/routting/routes.dart';

import 'src/services/services.dart';
import 'src/class/widgets/player.dart';

@Component(
  selector: 'my-app',
  styleUrls: [
    'app_component.scss.css'
  ],
  templateUrl: 'app_component.html',
  encapsulation: ViewEncapsulation.None,

  directives: [
    routerDirectives,
    //DrawerMenu,
    HeaderMenu,
    FooterComponent,
    PlayerBareComponent,
  ],
  providers: const [ 
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
    ],
  exports: [RoutePaths, Routes]
)
class AppComponent 
{

}

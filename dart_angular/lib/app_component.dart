import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/widgets/widgets.dart';
import 'src/services/services.dart';
import 'src/class/widgets/player.dart';
import 'src/services/user_service.dart';

@Component(
  selector: 'my-app',
  styleUrls: [
    'app_component.scss.css'
  ],
  templateUrl: 'app_component.html',
  encapsulation: ViewEncapsulation.None,

  directives: [
    AppShellComponent,
    PlayerBareComponent,
  ],
  providers: const [ 
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    ClassProvider(UserService),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
  ],
)
class AppComponent 
{

}

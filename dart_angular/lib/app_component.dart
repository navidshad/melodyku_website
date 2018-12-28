import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/widgets/widgets.dart';
import 'src/services/services.dart';
import 'src/routting/routes.dart';

import './src/class/injector.dart' as CI;
import './src/services/content_provider/requester.dart';

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
    ClassProvider(UserService),
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    ClassProvider(MessageService),
    ClassProvider(ModalService),
    ClassProvider(PageRoutes),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
  ],
)
class AppComponent 
{
  AppComponent()
  {
    registerIntoInjectory();
  }

  void registerIntoInjectory()
  {
    // these classes will be injected into Injectory with its own contructors
    UserService();
    Requester();
    ContentProvider();
  }
}

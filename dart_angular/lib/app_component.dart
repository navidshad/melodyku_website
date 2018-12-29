import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/widgets/widgets.dart';
import 'src/services/services.dart';
import 'src/routting/routes.dart';

import './src/services/content_provider/requester.dart';
import './src/class/injector.dart' as CI;

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
    ClassProvider(MessageService),
    ClassProvider(UserService),
    ClassProvider(Requester),
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    ClassProvider(ModalService),
    ClassProvider(PageRoutes),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
  ],
)
class AppComponent 
{
  AppComponent(UserService us, Requester rq, ContentProvider cp, MessageService ms)
  {
    // register this userService into Injectory.
    CI.Injector.register(CI.InjectorMember('UserService', us));
    CI.Injector.register(CI.InjectorMember('Requester', rq));
    CI.Injector.register(CI.InjectorMember('ContentProvider', cp));
    CI.Injector.register(CI.InjectorMember('MessageService', ms));
  }
}

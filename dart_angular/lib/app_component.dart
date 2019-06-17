import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/widgets/player.dart';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/core/injector.dart' as CI;

@Component(
  selector: 'my-app',
  styleUrls: [
    'app_component.css'
  ],
  templateUrl: 'app_component.html',
  encapsulation: ViewEncapsulation.None,

  directives: [
    coreDirectives,
    AppShellComponent,
    PlayerBareComponent,
  ],
  providers: const [
    ClassProvider(StitchService),
    ClassProvider(AnalyticService),
    ClassProvider(LanguageService),
    ClassProvider(MessageService),
    ClassProvider(UserService),
    ClassProvider(ContentProvider),
    ClassProvider(ModalService),
    ClassProvider(SubscriptionService),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
    ClassProvider(PlayerService),
  ],
)
class AppComponent
{
  
  AppComponent( StitchService stitch, AnalyticService ga,
    UserService us, ContentProvider cp, MessageService ms, 
    LanguageService lang, SubscriptionService subScription)
  {

    // register this userService into Injectory.
    CI.Injector.register(CI.InjectorMember('AnalyticService', ga));
    CI.Injector.register(CI.InjectorMember('StitchService', stitch));
    CI.Injector.register(CI.InjectorMember('LanguageService', lang));
    CI.Injector.register(CI.InjectorMember('UserService', us));
    CI.Injector.register(CI.InjectorMember('ContentProvider', cp));
    CI.Injector.register(CI.InjectorMember('MessageService', ms));
    CI.Injector.register(CI.InjectorMember('SubscriptionService', subScription));

    // login with last session
    us.loginWithLastSession();
  }
}

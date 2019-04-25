import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/services/stitch_service.dart';
import 'src/services/services.dart';

import 'src/widgets/widgets.dart';

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
    coreDirectives,
    AppShellComponent,
    PlayerBareComponent,
  ],
  providers: const [
    ClassProvider(StitchService),
    ClassProvider(MessageService),
    ClassProvider(UserService),
    ClassProvider(Requester),
    ClassProvider(ContentProvider),
    ClassProvider(PlayerService),
    ClassProvider(ModalService),
    ClassProvider(SubscriptionService),
    // player needs material-provider for seeker bar
    materialProviders,
    ClassProvider(Player),
  ],
)
class AppComponent
{
  //bool hasRedirect = true;

  AppComponent( StitchService stitch,
    UserService us, Requester rq, ContentProvider cp, MessageService ms, 
    LanguageService lang, SubscriptionService subScription)
  {
    //checkRedirect();

    // register this userService into Injectory.
    CI.Injector.register(CI.InjectorMember('StitchService', stitch));
    CI.Injector.register(CI.InjectorMember('LanguageService', lang));
    CI.Injector.register(CI.InjectorMember('UserService', us));
    CI.Injector.register(CI.InjectorMember('Requester', rq));
    CI.Injector.register(CI.InjectorMember('ContentProvider', cp));
    CI.Injector.register(CI.InjectorMember('MessageService', ms));
    CI.Injector.register(CI.InjectorMember('SubscriptionService', subScription));

    // login with last session
    us.loginWithLastSession();
  }

  // void checkRedirect()
  // {
  //   print('checkRedirect ${window.location}');

  //   String url = window.location.toString();
  //   String redirect;
    
  //   String rPattern = '?redirect=';
  //   if(url.contains(rPattern))
  //     redirect = url.split(rPattern)[1];
    
  //   if(redirect != null)
  //   {
  //     redirect = redirect.replaceAll('&', '/');
  //     redirect = redirect.replaceAll('=', '/');

  //     window.location.replace('/#${redirect}');
  //   }
  //   else hasRedirect = false;
  // }
}

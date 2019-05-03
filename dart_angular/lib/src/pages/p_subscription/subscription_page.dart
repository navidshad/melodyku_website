import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/page/page.dart';
import 'package:melodyku/src/widgets/subscription_plans_component/subscription_plans_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'subscription_page.html',
  styleUrls: [ 'subscription_page.css' ],
  directives: [
    coreDirectives,
    SubscriptionPlansComponent,
  ]
)
class SubscriptionPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  StitchService _stitchService;

  // constructor ==================================
  SubscriptionPage(this._stitchService, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'subscription');
  }
}
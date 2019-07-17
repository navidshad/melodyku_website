import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

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

  // constructor ==================================
  SubscriptionPage(this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'subscription');
  }
}
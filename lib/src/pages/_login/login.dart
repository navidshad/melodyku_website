import 'package:angular/angular.dart';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'login.html',
  styleUrls: [ 'login.css' ],
  directives: [
    coreDirectives,
    LoginForm2Component
  ]
)
class LoginPage
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;

  // constructor ==================================
  LoginPage(this.lang, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'login',
    );
  }
}
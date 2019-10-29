import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'users_page.html',
  styleUrls: [ 'users_page.css' ],
  directives: [
    PermissionManagerComponent,
    UserManagerComponent,
  ]
)
class UsersPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  UsersPage(this._contentProvider, this._messageService, this._userservice);

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.user_manager,
      needLogedIn: true,
      title: 'users');
  }
}
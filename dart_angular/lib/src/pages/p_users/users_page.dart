import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../widgets/admin/permission_manager/permission_manager.dart';
import '../../widgets/admin/user_manager/user_manager.dart';

@Component(
  selector: 'page',
  templateUrl: 'users_page.html',
  styleUrls: [ 'users_page.scss.css' ],
  directives: [
    PermissionManagerComponent,
    UserManagerComponent,
  ]
)
class UsersPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  UsersPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.user_manager,
      needLogedIn: true,
      title: 'users');
  }


}
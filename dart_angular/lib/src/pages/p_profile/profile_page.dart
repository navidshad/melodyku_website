import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/page/page.dart';

import 'package:melodyku/src/widgets/user/profile_editor/profile_editor.dart';
import 'package:melodyku/src/widgets/user/user_activity_detail/user_activity_detail.dart';

@Component(
  selector: 'page',
  templateUrl: 'profile_page.html',
  styleUrls: [ 'profile_page.css' ],
  directives: [
    ProfileEditor,
    UserActivityDetail,
  ]
)
class ProfilePage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  ProfilePage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'profile');
  }
}
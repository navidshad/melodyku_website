import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'profile_page.html',
  styleUrls: [ 'profile_page.css' ],
  directives: [
    ProfileEditor,
    UserActivityDetail,
  ]
)
class ProfilePage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  ProfilePage(this._contentProvider, this._messageService, this._userservice);

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'profile');
  }
}
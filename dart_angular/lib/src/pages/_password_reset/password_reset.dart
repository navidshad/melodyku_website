import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../services/stitch_service.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';

@Component(
  selector: 'page',
  templateUrl: 'password_reset.html',
  styleUrls: [ 'password_reset.scss.css' ],
  directives: [
    coreDirectives,
  ]
)
class PasswordResetPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  StitchService _stitch;

  // constructor ==================================
  PasswordResetPage(this._messageService, this._userservice, this._stitch)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'password_reset',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final token = current.parameters['token'];
    final tokenid = current.parameters['tokenId'];

    // get 
    UserPasswordAuthProviderClient emailPassClient = _stitch.appClient.auth.getProviderClient(userPasswordAuthProviderClientFactory);

    String newPass = '';
    //emailPassClient.resetPassword(token, tokenid, newPass);
  }
}
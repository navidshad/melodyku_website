import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../services/stitch_service.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';

@Component(
  selector: 'page',
  templateUrl: 'email_confirmation.html',
  styleUrls: [ 'email_confirmation.scss.css' ],
  directives: [
    coreDirectives,
  ]
)
class  EmailConfirmationPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  StitchService _stitch;

  // constructor ==================================
  EmailConfirmationPage(this._messageService, this._userservice, this._stitch)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'email_confirmation',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final token = current.parameters['token'];
    final tokenid = current.parameters['tokenId'];

    // get 
    UserPasswordAuthProviderClient emailPassClient = _stitch.appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    emailPassClient.confirmUser(token, tokenid);
  }
}
import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

@Component(
  selector: 'page',
  templateUrl: 'advanced_settings_page.html',
  //styleUrls: [ 'advanced_settings_page.scss.css' ],
)
class AdvancedSettingsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  AdvancedSettingsPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.advanced_settings,
      needLogedIn: true,
      title: 'advanced_settings'
    );
  }
}
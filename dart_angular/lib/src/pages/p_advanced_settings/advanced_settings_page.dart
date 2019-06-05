import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'advanced_settings_page.html',
  styleUrls: [ 'advanced_settings_page.css' ],
  directives: [
    mediaLanguageSettingsComponent,
    DbCollectionTableEditorComponent,
    TariffManagerComponent,
  ]
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
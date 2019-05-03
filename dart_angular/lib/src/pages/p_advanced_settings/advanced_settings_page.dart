import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../widgets/admin/media_language_settings/media_language_settings.dart';
import '../../widgets/admin/dbCollection_table_editor/dbCollection_table_editor.dart';
import '../../widgets/admin/tariff_manager/tariff_manager.dart';

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
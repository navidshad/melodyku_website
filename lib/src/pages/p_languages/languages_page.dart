import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'languages_page.html',
  styleUrls: [ 'languages_page.css' ],
  directives: [
    DbCollectionTableEditorComponent,
  ]
)
class LanguagesPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  CollectionOptions optionsLanguages;
  CollectionOptions optionsStrs;

  // constructor ==================================
  LanguagesPage(this._contentProvider, this._messageService, this._userservice)
  {
    optionsStrs = CollectionOptions(
      title: 'Manage Strings',
      database: 'cms',
      collection: 'languageStr',
      dbFields: SystemSchema.languageStr
    );

    optionsLanguages = CollectionOptions(
      title: 'Manage Languages',
      database: 'cms',
      collection: 'language_config',
      dbFields: SystemSchema.language
    );
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.advanced_settings,
      needLogedIn: true,
      title: 'Languages'
    );
  }
}
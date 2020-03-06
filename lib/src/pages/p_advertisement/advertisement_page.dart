import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'page',
  	template: 
  	'''
  	  <db-collection-table-editor	[options]="options"></db-collection-table-editor>
  	''',
  	//styleUrls: [ 'advanced_settings_page.css' ],
	directives: [
    DbCollectionTableEditorComponent,
  ]
)
class AdvertisementPage implements OnActivate {

  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  CollectionOptions options = CollectionOptions(
    database: 'cms',
    collection: 'advertisement',
    hasCover: true,
    dbFields: SystemSchema.advertisement
  );

  AdvertisementPage(this._contentProvider, this._messageService, this._userservice);

  @override
  void onActivate(_, RouterState current) async 
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.quality_management,
      needLogedIn: true,
      title: 'Advertisement'
    );
  }
}
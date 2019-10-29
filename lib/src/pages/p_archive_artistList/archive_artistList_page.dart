import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artistList_page.html',
  styleUrls: [ 'archive_artistList_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
  ]
)
class ArchiveArtistListPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;

  CollectionOptions options;

  // constructor ==================================
  ArchiveArtistListPage(this._categoryService, this._messageService, this._userservice)
  {
    options = CollectionOptions(
        title: 'Artists',
        database: 'media',
        collection:'artist',
        allowUpdate: false,
        allowAdd: true,
        allowRemove: true,
        hasCover: false,

        sort: { 'name': 1 },
        
        dbFields: SystemSchema.injectSubfields('categories', SystemSchema.artist, _categoryService.getGroups()),

        linkButtons: [
          LinkButton(
            title: 'detail', 
            route: pageDefinitions['archive_artist'].route, 
            parameters: ['_id']),
        ]
      );
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_artistList'
    );
  }
}
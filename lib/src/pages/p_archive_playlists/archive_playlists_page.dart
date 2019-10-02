import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_playlists_page.html',
  styleUrls: [ 'archive_playlists_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
  ]
)
class ArchivePlaylistsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;

  CollectionOptions options;

  // constructor ==================================
  ArchivePlaylistsPage(this._categoryService, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_playlists'
    );

    options = CollectionOptions(
      title: 'Playlists',
      database: 'media',
      collection:'playlist',
      allowUpdate: true,
      allowAdd: true,
      allowRemove: true,
      hasCover: true,

      sort: { '_id': -1 },
      
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.playlist, _categoryService.getGroups()),

      linkButtons: [
        LinkButton(
          title: 'edite list', 
          route: pageDefinitions['archive_playlist'].route, 
          parameters: ['_id']),
      ]
    );
  }
}
import 'package:angular/angular.dart';

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
class ArchiveArtistListPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  CollectionOptions options;

  // constructor ==================================
  ArchiveArtistListPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_artistList'
    );

    options = CollectionOptions(
        title:    'new field system',
        database: 'media',
        collection:'artist',
        allowUpdate: false,
        allowAdd: true,
        allowRemove: false,
        hasCover: false,
        
        dbFields: SystemSchema.artist,

        linkButtons: [
          LinkButton(
            title: 'detail', 
            route: pageDefinitions['archive_artist'].route, 
            parameters: ['_id']),
        ]
      );
  }
}
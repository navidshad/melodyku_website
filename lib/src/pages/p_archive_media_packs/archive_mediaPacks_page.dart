import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_mediaPacks_page.html',
  styleUrls: [ 'archive_mediaPacks_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
  ]
)
class ArchiveMediaPacksPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;

  CollectionOptions options;

  // constructor ==================================
  ArchiveMediaPacksPage(this._categoryService, this._messageService, this._userservice)
  {
    List<DbField> fields = SystemSchema.injectSubfields('categories', SystemSchema.mediaPack, _categoryService.getGroups());
    
    fields = SystemSchema.injectSubfields('type', fields, [
        DbField('artist', strvalue: 'artist'),
        DbField('album', strvalue: 'album'),
        DbField('playlist', strvalue: 'playlist')
      ]);

    options = CollectionOptions(
      title: 'Media Packs',
      database: 'media',
      collection:'media_pack',
      allowUpdate: true,
      allowAdd: true,
      allowRemove: true,
      hasCover: true,

      sort: { '_id': -1 },
      
      dbFields: fields,

      linkButtons: [
        LinkButton(
          title: 'edite list', 
          route: pageDefinitions['archive_media_pack'].route, 
          parameters: ['_id', 'type']),
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
      title: 'archive_media_packs'
    );
  }
}
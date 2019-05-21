import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';
import 'package:js/js_util.dart' as js;

import '../../services/services.dart';
import '../../services/stitch_service.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/collection_options.dart';

import '../../widgets/admin/dbCollection_table_editor/dbCollection_table_editor.dart';
import '../../widgets/admin/dbCollection_item_editor/dbCollection_item_editor.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_album_page.html',
  styleUrls: [ 'archive_album_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
  ]
)
class ArchiveAlbumPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;
  StitchService _stitch;

  String albumID;
  List<DbField> languages = [];
  CollectionOptions albumEditorOptions;
  CollectionOptions songOptions;
  

  // constructor ==================================
  ArchiveAlbumPage(this._contentProvider, this._messageService, this.lang, this._userservice, this._stitch)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_album'
    );
  }

  @override
  void onActivate(_, RouterState current)
  {
    albumID = current.parameters['_id'];
    prepareOptions(albumID);
  }

  void prepareOptions(String albumID) async
  {
    print('album prepareOptions');

    albumEditorOptions = CollectionOptions(
      hasCover: true,
      title:"detail",
      database: "media",
      collection:"album",
      id:albumID,
      dbFields: SystemSchema.album,
    );

    songOptions = CollectionOptions(
      hasCover: true,
      title:"songs",
      database: 'media',
      collection:"song",
      query: {'albumId': albumID},
      dbFields: SystemSchema.song,
    );
  }

  void _catchError(Error) => print(Error);
}
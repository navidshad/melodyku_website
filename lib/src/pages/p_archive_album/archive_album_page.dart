import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

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
  CategoryService _categoryService;
  PlayerService _playerService;

  String albumID;
  List<DbField> languages = [];
  CollectionOptions albumEditorOptions;
  CollectionOptions songOptions;
  

  // constructor ==================================
  ArchiveAlbumPage(this._playerService, this._categoryService, this._messageService, this.lang, this._userservice)
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
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.album, _categoryService.getGroups()),
    );

    songOptions = CollectionOptions(
      hasCover: true,
      title:"songs",
      database: 'media',
      allowAdd: false,
      collection:"song",
      types: [
        TypeCaster('ObjectId', '0.\$match.albumId')
      ],
      query: {'albumId': albumID},
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.song, _categoryService.getGroups()),
      actionButtons: [
        ActionButton(title:'play', onEvent: play),
      ],
    );
  }

  void play(Map doc, ButtonOptions options)
  {
    _playerService.playByID(doc['_id']);
  }

  void _catchError(Error) => print(Error);
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artist_page.html',
  styleUrls: [ 'archive_artist_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
  ]
)
class ArchiveArtistPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;
  StitchService _stitch;

  CollectionOptions AlbumTableOptions;
  CollectionOptions singleOptions;

  dynamic artist;

  // constructor ==================================
  ArchiveArtistPage(this._categoryService, this._messageService, this._userservice, this._stitch)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_artist'
    );
  }

  @override
  void onActivate(_, RouterState current)
  {
    String artistID = current.parameters['_id'];
    //print('artistID $artistID');
    prepareOptions(artistID);
  }

  void prepareOptions(String artistID) async
  {
    
    List<DbField> languages = [];

    singleOptions = CollectionOptions(
      hasCover: true,
      title:"detail",
      database: 'media',
      collection:"artist",
      id:artistID,
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.artist, _categoryService.getGroups()),
    );


    AlbumTableOptions = CollectionOptions(
      title: 'Manage Albums',
      database: 'media',
      collection: 'album',
      query: {'artistId': artistID},
      allowUpdate: false,
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.album, _categoryService.getGroups()),

      linkButtons: <LinkButton>[
        LinkButton(
          title: 'detail', 
          route: pageDefinitions['archive_album'].route, 
          parameters: ['_id']),
      ],
    );
  }

  void _catchError(Error) => print(Error);
}
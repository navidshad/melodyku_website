import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';

import '../../services/services.dart';
import '../../services/stitch_service.dart';

import '../../routting/routes.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/collection_options.dart';

import '../../widgets/admin/dbCollection_table_editor/dbCollection_table_editor.dart';
import '../../widgets/admin/dbCollection_item_editor/dbCollection_item_editor.dart';

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
  ContentProvider _contentProvider;
  StitchService _stitch;

  CollectionOptions AlbumTableOptions;
  CollectionOptions singleOptions;

  dynamic artist;

  // constructor ==================================
  ArchiveArtistPage(this._contentProvider, this._messageService, this._userservice, this._stitch)
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
      dbFields: SystemSchema.artist,
    );


    AlbumTableOptions = CollectionOptions(
      title: 'Manage Albums',
      database: 'media',
      collection: 'album',
      query: {'artistId': artistID},
      allowUpdate: false,
      dbFields: SystemSchema.album,

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
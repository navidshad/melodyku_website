import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artist_page.html',
  styleUrls: [ 'archive_artist_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent,
    DbCollectionItemEditorComponent,
    ElementExtractorDirective,
    musicUploaderComponent,
  ]
)
class ArchiveArtistPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;

  Modal modal;

  CollectionOptions AlbumTableOptions;
  CollectionOptions singleOptions;

  Map album;

  // constructor ==================================
  ArchiveArtistPage(
    this._categoryService, this._messageService, this._userservice)
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

  void getElement(Element el) 
  {
    modal = Modal(el);
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
      addOnCreate: {'artistId': artistID},
      allowUpdate: false,
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.album, _categoryService.getGroups()),

      linkButtons: <LinkButton>[
        LinkButton(
          title: 'detail', 
          route: pageDefinitions['archive_album'].route, 
          parameters: ['_id']),
      ],

      actionButtons: [
        ActionButton(title:'upload', onEvent: openUpload),
      ]
    );
  }

  Function openUpload(Map doc)
  {
    album = doc;
    modal.show();
  }

  void _catchError(Error) => print(Error);
}
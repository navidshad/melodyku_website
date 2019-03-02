import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';
import 'package:js/js_util.dart' as js;

import '../../services/services.dart';
import '../../services/stitch_service.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/single_item_object_property.dart';

import '../../widgets/admin/dbCollection_table/dbCollection_table.dart';
import '../../widgets/admin/single_item_editor/single_item_editor.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_album_page.html',
  styleUrls: [ 'archive_album_page.scss.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableComponent,
    SingleItemEditor,
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
  Map<String, SingleItemObjectProperty> languages = {};
  CollectionOptions albumEditorOptions;
  List<CollectionOptions> songsEditorOption = [];
  

  // constructor ==================================
  ArchiveAlbumPage(this._contentProvider, this._messageService, this._userservice, this._stitch)
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
    promiseToFuture(_stitch.dbClient.db('media').collection('language').find().asArray())
    .then((languageDocs) 
    {
      languageDocs.forEach((language) 
      {
          languages[language.code.toString()] = SingleItemObjectProperty(language.code.toString(), language.title);
      });

      albumEditorOptions = CollectionOptions(
        title:"detail",
        collection:"album",
        id:albumID,
        fields: ['title', 'singer', 'local_title'],
        stringObjects: ['local_title'],
        types: {
          'local_title': languages
        }
      );

    }).catchError(_catchError);

    dynamic songQuery = js.jsify({'albumId': albumID});
    promiseToFuture(_stitch.dbClient.db('media').collection('song').find(songQuery).asArray())
    .then((songs) 
    {
      songs.forEach((song) 
      {
        CollectionOptions songOption = CollectionOptions(
          title:"detail",
          collection:"song",
          document: song,
          fields: ['title', 'album', 'singer', 'genre', 'year', 'local_title'],
          stringObjects: ['local_title'],
          types: {
            'local_title': languages
          }
        ); 

        songsEditorOption.add(songOption);
      });

    }).catchError(_catchError);
  }

  void _catchError(Error) => print(Error);
}
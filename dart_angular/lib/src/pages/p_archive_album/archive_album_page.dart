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
  styleUrls: [ 'archive_album_page.scss.css' ],
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

    await promiseToFuture(_stitch.dbClient.db('media').collection('language').find().asArray())
    .then((languageDocs) 
    {
      languageDocs.forEach((language) 
      {
        DbField sField = DbField(language.code.toString(), customTitle: language.title);
        languages.add(sField);
      });

      albumEditorOptions = CollectionOptions(
        hasCover: true,
        title:"detail",
        database: "media",
        collection:"album",
        id:albumID,
        dbFields: [
          DbField('title'),
          DbField('singer', isDisable: true),
          DbField('description'),
          DbField('singerId', isDisable: true),
          DbField('local_title', subFields: languages,
            dataType: DataType.object, fieldType: FieldType.object),
        ],
      );

      songOptions = CollectionOptions(
        hasCover: true,
        title:"songs",
        database: 'media',
        collection:"song",
        query: {'albumId': albumID},
        dbFields: [
          DbField('title', dataType: DataType.string, fieldType: FieldType.text),
          DbField('album', isDisable: true),
          DbField('singer', isDisable: true),
          DbField('genre', dataType: DataType.string, fieldType: FieldType.select, subFields: []),
          DbField('year', dataType: DataType.int, fieldType: FieldType.text),
          DbField('local_title', subFields: languages,
            dataType: DataType.object, fieldType: FieldType.object),
        ]
      ); 

    }).catchError(_catchError);

    // dynamic songQuery = js.jsify({'albumId': albumID});
    // promiseToFuture(_stitch.dbClient.db('media').collection('song').find(songQuery).asArray())
    // .then((songs) 
    // {
    //   print('songs ${songs.length}');
    //   songs.forEach((song) 
    //   {
    //     CollectionOptions songOption = CollectionOptions(
    //       title:"detail",
    //       collection:"song",
    //       document: song,
    //       fields: ['title', 'album', 'singer', 'genre', 'year', 'local_title'],
    //       stringObjects: ['local_title'],
    //       types: {
    //         'local_title': languages
    //       }
    //     ); 

    //     songsEditorOption.add(songOption);
    //   });

    // }).catchError(_catchError);
  }

  void _catchError(Error) => print(Error);
}
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
import '../../widgets/admin/cover_item_editor/cover_item_editor.dart';
import '../../widgets/admin/single_item_editor/single_item_editor.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artist_page.html',
  styleUrls: [ 'archive_artist_page.scss.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableComponent,
    CoverItemEditor,
    SingleItemEditor,
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

  dynamic singer;

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
    String singerID = current.parameters['_id'];
    //print('singerID $singerID');
    prepareOptions(singerID);
  }

  void prepareOptions(String singerID) async
  {
    Map<String, SingleItemObjectProperty> languages = {};

    await promiseToFuture(_stitch.dbClient.db('media').collection('language').find().asArray())
    .then((languageDocs) 
    {
      languageDocs.forEach((language) 
      {
          languages[language.code.toString()] = SingleItemObjectProperty(language.code.toString(), language.title);
      });

      singleOptions = CollectionOptions(
        title:"detail",
        collection:"singer",
        id:singerID,
        fields: ['name', 'local_title'],
        stringObjects: ['local_title'],
        types: {
          'local_title': languages
        }
      );

    }).catchError(_catchError);


    AlbumTableOptions = CollectionOptions(
      query: {'singerId': singerID},
      allowUpdate: false,
      allowRemove: false,
      stringObjects: ['local_title'],
    );
  }

  void _catchError(Error) => print(Error);
}
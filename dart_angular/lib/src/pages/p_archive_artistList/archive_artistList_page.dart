import 'package:angular/angular.dart';

import '../../routting/routes.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../widgets/admin/dbCollection_table/dbCollection_table.dart';
import '../../widgets/admin/dbCollection_item_editor/dbCollection_item_editor.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artistList_page.html',
  styleUrls: [ 'archive_artistList_page.scss.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableComponent,
    dbCollection_item_editor,
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
  CollectionOptions item_editor_options;

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
      allowUpdate: false,
      allowRemove: false,
      linkButtons: <LinkButton>[
        LinkButton(
          title: 'detail', 
          route: pageDefinitions['archive_artist'].route, 
          parameters: ['_id']),
      ],
      stringObjects: ['local_title']
    );

    item_editor_options = CollectionOptions(
        title:    'new field system',
        database: 'media',
        collection:'language',
        id: '5c6a82dd89f5bddcf28fd254',
        dbFields: [
          DbField('code', dataType: DataType.string),
          DbField('title', dataType: DataType.string),
          DbField('title_en', dataType: DataType.string),
          DbField('isDefault', dataType: DataType.bool),
          DbField('selector', dataType: DataType.string, fieldType: FieldType.select,
            subFields: [
              DbField('option01', strvalue: 'option01'),
              DbField('option02', strvalue: 'option02'),
            ]),

          DbField('object', dataType: DataType.object,
            subFields: [
              DbField('field01', dataType: DataType.string),
              DbField('field02', dataType: DataType.bool),

              DbField('selector', dataType: DataType.string, fieldType: FieldType.select,
                subFields: [
                  DbField('option01', strvalue: 'option01'),
                  DbField('option02', strvalue: 'option02'),
                ]),
            ]),
        ]
      );
  }
}
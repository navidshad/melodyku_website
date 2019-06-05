import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_categories_page.html',
  styleUrls: [ 'archive_categories_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableEditorComponent
  ]
)
class ArchiveCategoriesPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;
  StitchService _stitch;

  CollectionOptions catrgoryOptions;
  CollectionOptions clusterOptions;

  // constructor ==================================
  ArchiveCategoriesPage(this._contentProvider, this._messageService, this._userservice, this._stitch)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.categorizing,
      needLogedIn: true,
      title: 'archive_categories');

    setupOptions();
  }

  void setupOptions() async 
  {
    List<DbField> clusterFilds = [];

    await promiseToFuture(_stitch.dbClient.db('media').collection('cluster').find().asArray())
    .then((clusters) 
    {
      clusters.forEach((doc) 
      {
        // dynamic converted = convertFromJS(doc, stringObjects: ['local_title']);
        // DbField field = DbField(
        //   converted['title'], strvalue: converted['_id'].toString());
        // clusterFilds.add(field);
      });

    }).catchError((error) => print(error));

    catrgoryOptions = CollectionOptions(
        title: 'Manage Categories',
        database: 'media',
        collection: 'category',
        dbFields: [
          DbField('title'),
          DbField('clusterId', fieldType: FieldType.select, subFields: clusterFilds),
          DbField('local_title', dataType: DataType.object, fieldType: FieldType.object)
        ],
      );

    clusterOptions = CollectionOptions(
      title: 'Manage Clusters',
      database: 'media',
      collection: 'cluster',
      dbFields: [
        DbField('title'),
        DbField('local_title', dataType: DataType.object, fieldType: FieldType.object)
      ],
    );
  }
}
import 'package:angular/angular.dart';
import 'dart:html';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../widgets/admin/dbCollection_table/dbCollection_table.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_categories_page.html',
  styleUrls: [ 'archive_categories_page.scss.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableComponent
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
    List<SubField> clusterFilds = [];

    await promiseToFuture(_stitch.dbClient.db('media').collection('cluster').find().asArray())
    .then((clusters) 
    {
      clusters.forEach((doc) 
      {
        dynamic converted = convertFromJS(doc, stringObjects: ['local_title']);
        SubField field = SubField(
          title: converted['title'],
          value: converted['_id'].toString(),
        );

        clusterFilds.add(field);
      });

    }).catchError((error) => print(error));

    catrgoryOptions = CollectionOptions(
        fields: ['title', 'clusterId', 'local_title'],
        types: {
          'clusterId': clusterFilds
        },
      );

    clusterOptions = CollectionOptions(
      fields: ['title', 'local_title'],
    );
  }
}
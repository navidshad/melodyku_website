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
  CategoryService _categoryService;

  CollectionOptions catrgoryOptions;
  CollectionOptions groupOptions;

  // constructor ==================================
  ArchiveCategoriesPage(this._categoryService, this._messageService, this._userservice)
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

    catrgoryOptions = CollectionOptions(
        hasCover: true,
        title: 'Manage Categories',
        database: 'media',
        collection: 'category',
        dbFields: SystemSchema.injectSubfields('groupId', 
            SystemSchema.category, _categoryService.getGroups()),
      );

    groupOptions = CollectionOptions(
      title: 'Manage groups',
      database: 'media',
      collection: 'category_group',
      dbFields: SystemSchema.category_group,
    );
  }
}
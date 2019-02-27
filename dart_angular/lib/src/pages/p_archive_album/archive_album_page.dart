import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../widgets/admin/dbCollection_table/dbCollection_table.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_album_page.html',
  styleUrls: [ 'archive_album_page.scss.css' ],
  directives: [
    coreDirectives,
    DbCollectionTableComponent
  ]
)
class ArchiveAlbumPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  CollectionOptions options;

  // constructor ==================================
  ArchiveAlbumPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_album'
    );

    options = CollectionOptions(
      allowUpdate: false,
      allowRemove: false,
      stringObjects: ['local_title'],
    );
  }
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_upload_page.html',
  styleUrls: [ 'archive_upload_page.css' ],
  )
class ArchiveUploadPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  ArchiveUploadPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_upload');
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_upload');
  }
}
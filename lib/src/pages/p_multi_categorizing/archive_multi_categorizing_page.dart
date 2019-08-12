import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_multi_categorizing_page.html',
  styleUrls: [ 'archive_multi_categorizing_page.css' ],
  directives: [
    coreDirectives,
    MultiCategorizingComponent,
  ]
)
class ArchiveMultiCategorizingPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;

  // constructor ==================================
  ArchiveMultiCategorizingPage(this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.categorizing,
      needLogedIn: true,
      title: 'multi_categorizing');
  }
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'search_page.html',
  styleUrls: [ 'search_page.css' ],
  directives: [
    coreDirectives,
    SearchComponent,
  ]
)
class SearchPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  SearchPage(this._contentProvider, this._messageService, this._userservice);

  @override
  void onActivate(_, RouterState current) async 
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'search',
    );
  }
}
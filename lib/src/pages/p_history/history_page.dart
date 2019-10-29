import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'history_page.html',
  styleUrls: [ 'history_page.css' ],
  directives: [ TableSong ],
  )
class HistoryPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;

  ResultWithNavigator<Song> songNavigator;

  // constructor ==================================
  HistoryPage(this._messageService, this._userservice)
  {
    songNavigator = ResultWithNavigator(getType: GetType.history, isLive:true);
    songNavigator.loadNextPage();
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'history');
  }
}
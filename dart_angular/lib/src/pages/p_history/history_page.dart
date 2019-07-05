import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

import 'package:melodyku/stitch_cloner/stitch_cloner.dart' as SC;

@Component(
  selector: 'page',
  templateUrl: 'history_page.html',
  styleUrls: [ 'history_page.css' ],
  directives: [ TableSong ],
  )
class HistoryPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;

  SC.ResultWithNavigator<Song> songNavigator;

  // constructor ==================================
  HistoryPage(this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'history');

    songNavigator = SC.ResultWithNavigator(getType: SC.GetType.history);
    songNavigator.loadNextPage();
  }
}
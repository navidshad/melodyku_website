import 'package:angular/angular.dart';
import 'package:melodyku/src/widgets/table_media_component/table_media_component.dart';
import 'package:melodyku/src/class/classes.dart';
import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/page/page.dart';

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

  ResultWithNavigator<Song> songNavigator;

  // constructor ==================================
  HistoryPage(this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'history');

    songNavigator = ResultWithNavigator(getType: GetType.history);
    songNavigator.loadNextPage();
  }
}
import 'package:angular/angular.dart';
import 'package:melodyku/src/widgets/table_media_component/table_media_component.dart';
import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/page/page.dart';
import 'package:melodyku/src/class/classes.dart';

@Component(
  selector: 'page',
  templateUrl: 'favorites_page.html',
  styleUrls: [ 'favorites_page.css' ],
  directives: [ TableSong ],
  )
class FavoritesPage
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  PlayerService _playerService;

  ResultWithNavigator<Song> songNavigator;

  // constructor ==================================
  FavoritesPage(this.lang, this._messageService, this._userservice, this._playerService)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'favorites');

    songNavigator = ResultWithNavigator(getType: GetType.favorites);
    songNavigator.loadNextPage();
  }

  void playAll() =>
    _playerService.playByList(songNavigator.list);
}
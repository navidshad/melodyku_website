import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'favorites_page.html',
  styleUrls: [ 'favorites_page.css' ],
  directives: [ 
    TableSong,
    PopMenuComponent,
  ],
  exports: [
    getSingleAlbumMenuItems,
  ]
  )
class FavoritesPage implements OnActivate 
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
    songNavigator = ResultWithNavigator(getType: GetType.favorites, isLive:true);
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
      title: 'favorites');
  }

  void playAll() =>
    _playerService.playByList(songNavigator.list);
}
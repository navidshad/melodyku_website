import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../class/result_list/result_playlist.dart';
import '../../class/archive/playlist.dart';
import '../../class/widgets/card.dart';
import '../../class/widgets/list_item.dart';

import '../../widgets/list_wide_component/list_wide_component.dart';
import '../../widgets/slider_rect_component/slider_rect_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'playlists_page.html',
  styleUrls: [ 'playlists_page.scss.css' ],
  directives: [
    coreDirectives,
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
)
class PlaylistsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<ListItem> dayList = [];
  List<Card> weekList = [];
  List<ListItem> randomList = [];
  List<Card> allList = [];

  // constructor ==================================
  PlaylistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'playlists',
    );

    getContent();
  }

  void getContent() async 
  {
    Playlist pl_day = await _contentProvider.archive.playlist_getById('5bfd635ccb6db178f4e4b14e');
    dayList = pl_day.getChildsAsWidgets<ListItem>(total: 15);

    Playlist pl_week = await _contentProvider.archive.playlist_getById('5ba8f3018f5e0509f0b3d1cc');
    weekList = pl_week.getChildsAsWidgets<Card>(total: 15);

    Playlist pl_random = await _contentProvider.archive.playlist_getById('5ba8f3108f5e0509f0b3d1cd');
    randomList = pl_random.getChildsAsWidgets<ListItem>(total: 15);


    Result_Playlist rPlaylists_All = await _contentProvider.archive.playlist_getList();

    rPlaylists_All.list.forEach((pl) {
      allList.add(pl.getAsWidget<Card>());
    });
  }
}
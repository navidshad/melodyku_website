import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/math.dart';

import '../../class/result_list/result_media.dart';
import '../../class/widgets/card.dart';
import '../../class/widgets/list_item.dart';

import '../../widgets/list_wide_component/list_wide_component.dart';
import '../../widgets/slider_rect_component/slider_rect_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'top_tracks_page.html',
  styleUrls: [ 'top_tracks_page.scss.css' ],
  directives: [
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
  )
class TopTracksPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<ListItem> top15Songs = [];
  List<Card> topOfAllTime = [];
  List<Card> lastSongs = [];

  // constructor ==================================
  TopTracksPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'top_tracks'
    );

    getContent();
  }

  void getContent() async 
  {

    Result_Media rMedia_top15 = await _contentProvider.archive
      .media_getAll(randomRange(0, 50), total: 15);

    rMedia_top15.list.forEach((song) {
      top15Songs.add(song.getAsWidget<ListItem>());
    });

    Result_Media rMedia_allTime = await _contentProvider.archive
      .media_getAll(randomRange(0, 50), total: 10);

    rMedia_allTime.list.forEach((song) {
      topOfAllTime.add(song.getAsWidget<Card>());
    });

    Result_Media rMedia_last = await _contentProvider.archive
      .media_getAll(randomRange(0, 50), total: 20);

    rMedia_last.list.forEach((song) {
      lastSongs.add(song.getAsWidget<Card>());
    });      
  }
}
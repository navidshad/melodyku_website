import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/math.dart';

import '../../class/archive/result_with_navigator.dart';
import '../../class/widgets/card.dart';
import '../../class/widgets/list_item.dart';

import '../../widgets/list_wide_component/list_wide_component.dart';
import '../../widgets/slider_rect_component/slider_rect_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'albums_page.html',
  styleUrls: [ 'albums_page.css' ],
  directives: [
    coreDirectives,
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
)
class AlbumsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<Card> featuredAlbums = [];
  List<Card> lastAlbums = [];
  List<ListItem> top15albums = [];

  // constructor ==================================
  AlbumsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'albums',
    );

    getContent();
  }

    void getContent() async 
  {

    ResultWithNavigator rAlbums_featured = await _contentProvider.stitchArchive
      .album_getList(randomRange(0, 50), total: 10);

    rAlbums_featured.list.forEach((album) 
      => featuredAlbums.add(album.getAsWidget<Card>()));

    ResultWithNavigator ralbums_tops = await _contentProvider.stitchArchive
      .album_getList(randomRange(0, 50), total: 15);

    ralbums_tops.list.forEach((album) {
      top15albums.add(album.getAsWidget<ListItem>());
    });

    ResultWithNavigator ralbums_Lasts = await _contentProvider.stitchArchive
      .album_getList(randomRange(0, 50), total: 20);

    ralbums_Lasts.list.forEach((album) {
      lastAlbums.add(album.getAsWidget<Card>());
    });
  }
}
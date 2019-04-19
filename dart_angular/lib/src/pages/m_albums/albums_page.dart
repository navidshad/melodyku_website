import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/math.dart';

import '../../class/result_list/result_album.dart';
import '../../class/widgets/card.dart';
import '../../class/widgets/list_item.dart';

import '../../widgets/list_wide_component/list_wide_component.dart';
import '../../widgets/slider_rect_component/slider_rect_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'albums_page.html',
  styleUrls: [ 'albums_page.scss.css' ],
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

    Result_Album rArtists_featured = await _contentProvider.archive
      .album_getAll(randomRange(0, 50), total: 10);

    rArtists_featured.list.forEach((artist) {
      featuredAlbums.add(artist.getAsWidget<Card>());
    });

    Result_Album rArtists_tops = await _contentProvider.archive
      .album_getAll(randomRange(0, 50), total: 15);

    rArtists_tops.list.forEach((artist) {
      top15albums.add(artist.getAsWidget<ListItem>());
    });

    Result_Album rArtists_Lasts = await _contentProvider.archive
      .album_getAll(randomRange(0, 50), total: 20);

    rArtists_Lasts.list.forEach((artist) {
      lastAlbums.add(artist.getAsWidget<Card>());
    });
  }
}
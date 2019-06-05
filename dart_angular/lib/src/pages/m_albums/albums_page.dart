import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'albums_page.html',
  styleUrls: [ 'albums_page.css' ],
  directives: [
    coreDirectives,
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
  List<Card> top15albums = [];

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
      top15albums.add(album.getAsWidget<Card>());
    });

    ResultWithNavigator ralbums_Lasts = await _contentProvider.stitchArchive
      .album_getList(randomRange(0, 50), total: 20);

    ralbums_Lasts.list.forEach((album) {
      lastAlbums.add(album.getAsWidget<Card>());
    });
  }
}
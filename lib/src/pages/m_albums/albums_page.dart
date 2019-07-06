import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

import 'package:melodyku/stitch_cloner/stitch_cloner.dart' as SC;

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

    List<Album> rAlbums_featured = await _contentProvider.stitchClonerArchive
      .album_getRandomList(total:10);

    rAlbums_featured.forEach((album) 
      => featuredAlbums.add(album.getAsWidget<Card>()));

    List<Album> ralbums_tops = await _contentProvider.stitchClonerArchive
      .album_getRandomList(total:15);

    ralbums_tops.forEach((album) {
      top15albums.add(album.getAsWidget<Card>());
    });

    List<Album> ralbums_Lasts = await _contentProvider.stitchClonerArchive
      .album_getRandomList(total:20);

    ralbums_Lasts.forEach((album) {
      lastAlbums.add(album.getAsWidget<Card>());
    });
  }
}
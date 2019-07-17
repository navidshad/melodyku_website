import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';


@Component(
  selector: 'page',
  templateUrl: 'artists_page.html',
  styleUrls: [ 'artists_page.css' ],
  directives: [
    coreDirectives,
    GridComponent,
    SliderRectComponent,
    ArtistsExplorerComponent,
  ]
  )
class ArtistsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<Card> featuredArtists = [];
  List<Card> topArtists = [];

  // constructor ==================================
  ArtistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'artists'
    );

    getContent();
  }

  void getContent() async 
  {

    ResultWithNavigator rArtists_featured = await _contentProvider.mediaselector
      .artist_getList(randomRange(0, 50), total: 10);

    rArtists_featured.list.forEach((artist) {
      featuredArtists.add(artist.getAsWidget<Card>());
    });

    ResultWithNavigator rArtists_tops = await _contentProvider.mediaselector
      .artist_getList(randomRange(0, 50), total: 20);

    rArtists_tops.list.forEach((artist) {
      topArtists.add(artist.getAsWidget<Card>());
    });
  }
}
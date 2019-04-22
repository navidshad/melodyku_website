import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/math.dart';

import '../../class/archive/result_with_navigator.dart';
import '../../class/widgets/card.dart';

import '../../widgets/grid_component/grid_component.dart';
import '../../widgets/slider_rect_component/slider_rect_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'artists_page.html',
  styleUrls: [ 'artists_page.scss.css' ],
  directives: [
    coreDirectives,
    GridComponent,
    SliderRectComponent,
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

    ResultWithNavigator rArtists_featured = await _contentProvider.stitchArchive
      .artist_getList(randomRange(0, 50), total: 10);

    rArtists_featured.list.forEach((artist) {
      featuredArtists.add(artist.getAsWidget<Card>());
    });

    ResultWithNavigator rArtists_tops = await _contentProvider.stitchArchive
      .artist_getList(randomRange(0, 50), total: 20);

    rArtists_tops.list.forEach((artist) {
      topArtists.add(artist.getAsWidget<Card>());
    });
  }
}
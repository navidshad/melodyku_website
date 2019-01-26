import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/utility/math.dart';

import '../../class/result_list/result_singer.dart';
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

  List<Card> featuredSingers = [];
  List<Card> topSingers = [];

  // constructor ==================================
  ArtistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'artists'
    );

    getContent();
  }

  void getContent() async 
  {

    Result_Singer rSingers_featured = await _contentProvider.archive
      .singer_getList(randomRange(0, 50), total: 10);

    rSingers_featured.list.forEach((singer) {
      featuredSingers.add(singer.getAsWidget<Card>());
    });

    Result_Singer rSingers_tops = await _contentProvider.archive
      .singer_getList(randomRange(0, 50), total: 20);

    rSingers_tops.list.forEach((singer) {
      topSingers.add(singer.getAsWidget<Card>());
    });
  }
}
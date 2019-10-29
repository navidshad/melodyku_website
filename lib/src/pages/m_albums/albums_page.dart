import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

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
  ],
)
class AlbumsPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Map tl_albums01;
  Map tl_albums02;

  List<Card> card_albums01 = [];
  List<Card> card_albums02 = [];
  List<Card> card_random = [];

  // constructor ==================================
  AlbumsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    getContent();
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'albums',
    );
  }

  void getContent() async 
  {

    await _contentProvider.mediaselector.mediaPack_get(title:'albums_page_02')
          .then((r) {
               tl_albums02 = r.localTitle;
               card_albums02 = r.getChildsAsCardWidgets();
          });
          
    await _contentProvider.mediaselector.mediaPack_get(title:'albums_page_01')
          .then((r) {
               tl_albums01 = r.localTitle;
               card_albums01 = r.getChildsAsCardWidgets();
          });

    await _contentProvider.mediaselector.album_getRandomList(total:9)
          .then((List<Album> r){
             r.forEach((album) => card_random.add( album.getAsWidget<Card>() ));
          });
  }
}
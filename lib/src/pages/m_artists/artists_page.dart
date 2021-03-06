import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

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
class ArtistsPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Map tl_artists01;
  List<Card> card_artists01 = [];

  Map tl_artists02;
  List<Card> card_artists02 = [];

  Map tl_artists03;
  List<Card> card_artists03 = [];

  // constructor ==================================
  ArtistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
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
      title: 'artists'
    );
  }

  void getContent() async 
  {

    await _contentProvider.mediaselector.mediaPack_get(title:'artists_page_trends')
          .then((r) {
               tl_artists01 = r.localTitle;
               card_artists01 = r.getChildsAsCardWidgets();
          });

    await _contentProvider.mediaselector.mediaPack_get(title:'artists_page_women')
          .then((r) {
               tl_artists02 = r.localTitle;
               card_artists02 = r.getChildsAsCardWidgets();
          });

    await _contentProvider.mediaselector.mediaPack_get(title:'artists_page_kings')
          .then((r) {
               tl_artists03 = r.localTitle;
               card_artists03 = r.getChildsAsCardWidgets();
          });
  }
}
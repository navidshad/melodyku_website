import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'vitrin_page.html',
  styleUrls: ['vitrin_page.css'],
  directives: [
    coreDirectives,
    SliderRectComponent,
    ListWideComponent,
    GridComponent,
    SlideShowComponent,
    CategoryPresentorComponent,
    FooterComponent,
    CTARegisterComponent,
    AdvertisementPresentor,
  ],
)
class VitrinPage implements OnActivate {
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  bool get isLogedIn => _userservice.isLogedIn;

  Map tl_lastSongs;
  List<ListItem> listItems_lastSongs = [];

  Map tl_mediaPack_playlists;
  List<Card> card_playlists = [];

  Map tl_mediaPack_best_albums;
  List<Card> card_best_albums = [];

  Map tl_mediaPack_artist;
  List<Card> card_artist = [];

  // constructor ==================================
  VitrinPage(this.lang, this._contentProvider, this._messageService,
      this._userservice) {
    getItems();
  }

  @override
  void onActivate(_, RouterState current) async {
    _page = Page(
        userService: _userservice,
        messageService: _messageService,
        permissionType: PermissionType.customer_access,
        needLogedIn: false,
        title: 'vitrin');
  }

  void getItems() async {
    await _contentProvider.mediaselector
        .getItem<Playlist>({'title': 'vitrin_page_01'}).then((r) {
      tl_lastSongs = (r as Playlist).localTitle;
      listItems_lastSongs =
          (r as Playlist).getChildsAsWidgets<ListItem>(total: 15);
    });

    await _contentProvider.mediaselector
        .mediaPack_get(title: 'vitrin_page_playlists')
        .then((r) {
      tl_mediaPack_playlists = r.localTitle;
      card_playlists = r.getChildsAsCardWidgets();
    });

    await _contentProvider.mediaselector
        .mediaPack_get(title: 'vitrin_page_albums')
        .then((r) {
      tl_mediaPack_best_albums = r.localTitle;
      card_best_albums = r.getChildsAsCardWidgets();
    });

    await _contentProvider.mediaselector
        .mediaPack_get(title: 'vitrin_page_artists')
        .then((r) {
      tl_mediaPack_artist = r.localTitle;
      card_artist = r.getChildsAsCardWidgets();
    });
  }

  List<ListItem> getListItems(Playlist pl) {
    List<ListItem> list = [];

    if (pl != null) list = pl.getChildsAsWidgets<ListItem>(total: 15);

    return list;
  }

  List<Card> getCards(MediaPack mp) {
    List<Card> list = [];

    if (mp != null) list = mp.getChildsAsCardWidgets();

    return list;
  }
}

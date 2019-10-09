import 'package:angular/angular.dart';

import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'vitrin_page.html',
  styleUrls: [ 'vitrin_page.css' ],
  directives: [
     coreDirectives,
     SliderRectComponent,
     ListWideComponent,
     GridComponent,
     SlideShowComponent,
     CategoryPresentorComponent,
     FooterComponent,
  ],
)
class VitrinPage
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Map tl_lastSongs;
  Map tl_mediaPack_women_artist;  
  Map tl_mediaPack_best_albums;
  Map tl_mediaPack_kurdish_kings;

  List<ListItem> listItems_lastSongs = [];
  List<Card> card_women_artist = [];
  List<Card> card_best_albums = [];
  List<Card> card_kurdish_kings = [];

  // constructor ==================================
  VitrinPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'vitrin'
    );

    getItems();
  }

  void getItems() async 
  {
     await _contentProvider.mediaselector.getItem<Playlist>({'title':'vitrin_page_01'})
          .then((r) {
               tl_lastSongs = (r as Playlist).localTitle;
               listItems_lastSongs = (r as Playlist).getChildsAsWidgets<ListItem>(total:15);
          });

     await _contentProvider.mediaselector.mediaPack_get(title:'vitrin_page_01')
          .then((r) {
               tl_mediaPack_women_artist = r.localTitle;
               card_women_artist = r.getChildsAsCardWidgets();
          });

     await _contentProvider.mediaselector.mediaPack_get(title:'vitrin_page_02')
          .then((r) {
               tl_mediaPack_best_albums = r.localTitle;
               card_best_albums = r.getChildsAsCardWidgets();
          });

     await _contentProvider.mediaselector.mediaPack_get(title:'vitrin_page_03')
          .then((r) {
               tl_mediaPack_kurdish_kings = r.localTitle;
               card_kurdish_kings = r.getChildsAsCardWidgets();
          });
  }

  List<ListItem> getListItems(Playlist pl)
  {
     List<ListItem> list = [];

     if(pl != null)
          list = pl.getChildsAsWidgets<ListItem>(total: 15);

     return list;
  }

  List<Card> getCards(MediaPack mp)
  {
     List<Card> list = [];

     if(mp != null)
          list = mp.getChildsAsCardWidgets();

     return list;
  }
}
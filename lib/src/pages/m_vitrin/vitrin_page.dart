import 'package:angular/angular.dart';

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

  List<Card> card_best_albums = [];

  List<Card> card_top10_month = [];
  List<Card> card_for_you = [];
  List<ListItem> listItems_top15_day = [];
  

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
  
  // get 
  Playlist pl_top10_month = await _contentProvider.mediaselector.playlist_getRamdom('برترین های تاریخ');
  card_top10_month = pl_top10_month.getChildsAsWidgets<Card>(total: 10);

  //print('pl_top10_month ${pl_top10_month.list.length}');

  // get forYou list
  //String p_forYou_id = '5ba8f3018f5e0509f0b3d1cc';
  Playlist pl_for_you = await _contentProvider.mediaselector.playlist_getRamdom('برای شما');
  card_for_you = pl_for_you.getChildsAsWidgets<Card>(total: 10);


  // get 15 top media of day
  //String p_day_id = '5ba8a5cf31243004332bd45a';
  Playlist pl_top15_day = await _contentProvider.mediaselector.playlist_getRamdom('پیشنهاد های امروز');
  listItems_top15_day = pl_top15_day.getChildsAsWidgets<ListItem>(total: 15);

  MediaPack mediaPack_besrAlbums = await _contentProvider.mediaselector.mediaPack_get(title:'best albums');
  card_best_albums = mediaPack_besrAlbums.getChildsAsCardWidgets();
 }
}
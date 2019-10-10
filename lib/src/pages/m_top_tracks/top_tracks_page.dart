import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'top_tracks_page.html',
  styleUrls: [ 'top_tracks_page.css' ],
  directives: [
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
  )
class TopTracksPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Map tl_list01;
  List<ListItem> listItem_list01 = [];

  Map tl_list02;
  List<ListItem> listItem_list02 = [];

  Map tl_list03;
  List<ListItem> listItem_list03 = [];

  // Map tl_list04;
  // List<ListItem> listItem_list04 = [];

  // constructor ==================================
  TopTracksPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'top_tracks'
    );

    getContent();
  }

  void getContent() async 
  {
    await _contentProvider.mediaselector.getItem<Playlist>({'title':'songs_page_list_01'})
      .then((r) {
       tl_list01 = (r as Playlist).localTitle;
       listItem_list01 = (r as Playlist).getChildsAsWidgets<ListItem>(total:15);
      });

    await _contentProvider.mediaselector.getItem<Playlist>({'title':'songs_page_list_02'})
      .then((r) {
       tl_list02 = (r as Playlist).localTitle;
       listItem_list02 = (r as Playlist).getChildsAsWidgets<ListItem>(total:15);
      }); 

    await _contentProvider.mediaselector.getItem<Playlist>({'title':'songs_page_list_03'})
      .then((r) {
       tl_list03 = (r as Playlist).localTitle;
       listItem_list03 = (r as Playlist).getChildsAsWidgets<ListItem>(total:15);
      }); 

    // await _contentProvider.mediaselector.getItem<Playlist>({'title':'songs_page_list_04'})
    //   .then((r) {
    //    tl_list04 = (r as Playlist).localTitle;
    //    listItem_list04 = (r as Playlist).getChildsAsWidgets<ListItem>(total:15);
    //   });     
  }
}
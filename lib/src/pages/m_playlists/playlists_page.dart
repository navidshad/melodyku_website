import 'package:angular/angular.dart';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'playlists_page.html',
  styleUrls: [ 'playlists_page.css' ],
  directives: [
    coreDirectives,
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
)
class PlaylistsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<ListItem> dayList = [];
  List<Card> weekList = [];
  List<ListItem> randomList = [];
  List<Card> allList = [];

  // constructor ==================================
  PlaylistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'playlists',
    );

    getContent();
  }

  void getContent() async 
  {
    _contentProvider.mediaselector.playlist_getList()
    .then((rv)
    {
      rv.list.forEach((pl)
      {
        Playlist casted = pl;
        allList.add(casted.getAsWidget<Card>());
      });
    });
  }
}
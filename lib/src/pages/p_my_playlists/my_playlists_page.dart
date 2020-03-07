import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'my_playlists_page.html',
  styleUrls: [ 'my_playlists_page.css' ],
  directives: [
    coreDirectives,
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
)
class MyPlaylistsPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<Card> allList = [];
  ResultWithNavigator<UserPlaylist> navigator;

  // constructor ==================================
  MyPlaylistsPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    getContent();
    _messageService.addListener('myPlaylists', resiveMessage);
  }

  void resiveMessage(MessageDetail message)
  {
    if(message.type.index != MessageType.userPlaylist.index) return;

    allList = [];
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
      title: 'myPlaylists',
    );
  }

  void getContent() async 
  {
    _contentProvider.mediaselector.userplaylist_getList()
    .then((rv)
    {
      navigator = rv;
      navigator.list.forEach((pl)
      {
        UserPlaylist casted = pl;
        allList.add(casted.getAsWidget<Card>());
      });
    });
  }
}
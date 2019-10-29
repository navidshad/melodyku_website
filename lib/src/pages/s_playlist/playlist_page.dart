import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'playlist_page.html',
  styleUrls: [ 'playlist_page.css' ],
  directives: [
    coreDirectives,
    AlbumSingleWrapperComponent,
  ]
)
class PlaylistPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Playlist playlist;
  String playlistId;

  // constructor ==================================
  PlaylistPage(this._contentProvider, this.lang, this._messageService, this._userservice);

  @override
  void onActivate(_, RouterState current) async 
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'playlist',
    );
    
    playlistId = current.parameters['id'];
    getPlaylist();
  }

  void getPlaylist()
  {
    _contentProvider.mediaselector.getItemByID<Playlist>(playlistId)
      .then((resultPlaylist) 
      {
        playlist = resultPlaylist;
        print(playlist.title);
      });
  }
}
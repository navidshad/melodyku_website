import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/archive/playlist.dart';

import '../../widgets/album_single_wrapper_component/album_single_wrapper_component.dart';

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

  // constructor ==================================
  PlaylistPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'playlist',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final id = current.parameters['id'];

    // get album
    playlist = await _contentProvider.archive.playlist_getById(id);
  }
}
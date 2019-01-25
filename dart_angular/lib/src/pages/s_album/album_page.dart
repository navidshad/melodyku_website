import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/archive/album.dart';

import '../../widgets/album_single_wrapper_component/album_single_wrapper_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'album_page.html',
  styleUrls: [ 'album_page.scss.css' ],
  directives: [
    coreDirectives,
    AlbumSingleWrapperComponent,
  ]
)
class AlbumPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Album album;

  // constructor ==================================
  AlbumPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'album',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final id = current.parameters['id'];

    // get album
    album = await _contentProvider.archive.album_getById(id);
  }
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/archive/singer.dart';

@Component(
  selector: 'page',
  templateUrl: 'artist_page.html',
  styleUrls: [ 'artist_page.scss.css' ],
  )
class ArtistPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Singer singer;

  // constructor ==================================
  ArtistPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService,
      permissionType: PermissionType.freemium_access,
      needLogedIn: false,
      title: 'artist'
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final id = current.parameters['id'];

    // get playlist
    singer = await _contentProvider.archive.singer_get(id);
  }
}
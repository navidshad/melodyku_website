import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/archive/artist.dart';
import '../../class/result_list/result_media.dart';
import '../../class/result_list/result_album.dart';
import '../../class/archive/media.dart';
import '../../class/widgets/card.dart';

import '../../widgets/album_single_wrapper_component/album_single_wrapper_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'artist_page.html',
  styleUrls: [ 'artist_page.scss.css' ],
  directives: [
    coreDirectives,
    AlbumSingleWrapperComponent,
    GridComponent,
  ]
  )
class ArtistPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  Artist artist;
  List<Media> topList = [];
  List<Card> albums = [];

  // constructor ==================================
  ArtistPage(this._contentProvider, this.lang, this._messageService, this._userservice)
  {
    _page = Page(      
      userService: _userservice, 
      messageService: _messageService,
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'artist',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    final id = current.parameters['id'];

    // get playlist
    artist = await _contentProvider.archive.artist_getById(id);

    // get 10 song of artist
    Result_Media rMedia = await _contentProvider.archive.media_getList(artist.name, 1, total: 10);
    topList = rMedia.list;

    // get albums
    Result_Album rAlbums = await _contentProvider.archive.album_getList(artist.name);
    rAlbums.list.forEach((album) {
      albums.add(album.getAsWidget<Card>());
    });
  }
}
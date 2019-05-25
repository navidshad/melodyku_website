import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';
import '../../class/archive/artist.dart';
import '../../class/archive/result_with_navigator.dart';
import '../../class/archive/song.dart';
import '../../class/widgets/card.dart';

import '../../widgets/album_single_wrapper_component/album_single_wrapper_component.dart';
import '../../widgets/grid_component/grid_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'artist_page.html',
  styleUrls: [ 'artist_page.css' ],
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
  ResultWithNavigator<Song> topListNavigator;
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

    // get detail
    artist = await _contentProvider.stitchArchive.getItemByID<Artist>(id);

    // get 10 song of artist
    topListNavigator = await _contentProvider.stitchArchive.song_getListByArtist(artist.id, page: 1, total: 10);
    topListNavigator.hasMore = false;

    // get albums
    ResultWithNavigator rAlbums = await _contentProvider.stitchArchive.album_getListByArtist(artist.id);
    rAlbums.list.forEach((album) {
      albums.add(album.getAsWidget<Card>());
    });
  }
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

import 'package:melodyku/stitch_cloner/stitch_cloner.dart' as SC;

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
  SC.ResultWithNavigator<Song> topListNavigator;
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
    artist = await _contentProvider.stitchClonerArchive.getItemByID<Artist>(id);

    // get 10 song of artist
    topListNavigator = await _contentProvider.stitchClonerArchive.song_getListByArtist(artist.id, page: 1, total: 10);
    topListNavigator.hasMore = false;

    // get albums
    SC.ResultWithNavigator rAlbums = await _contentProvider.stitchClonerArchive.album_getListByArtist(artist.id);
    rAlbums.list.forEach((album) {
      albums.add(album.getAsWidget<Card>());
    });
  }
}
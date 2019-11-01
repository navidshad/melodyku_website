import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'downloads_page.html',
  styleUrls: [ 'downloads_page.css' ],
  directives: [
    QuotaUsageComponent,
    TableSong,
  ]
  )
class DownloadsPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  IndexedDBService _idb;
  ContentProvider _provider;
  PlayerService _playerService;

  List<Song> songs = [];
  List<ActionButton> actions = [];

  // constructor ==================================
  DownloadsPage(this.lang, this._provider, this._idb, this._messageService, this._userservice, this._playerService)
  {
    actions = [
      ActionButton(title: 'delete', onEvent: removeSong),
    ];

    prepare();
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'downloads');
  }

  void playAll() =>
    _playerService.playByList(songs);

  void prepare() async
  {
    songs = [];
    ObjectStore songColl = await _idb.getCollection('media', 'song');

    songColl.openCursor()
      .listen((CursorWithValue cursor) async
      {
        if(cursor != null) cursor.next();
        else {
          sortlist();
          return;
        }

        Map songDetail =  validateFields(cursor.value, SystemSchema.song);
        songDetail['storedDate'] = cursor.value['storedDate'];

        // get artist
        Map artistDetail = await _idb.getOne('media', 'artist', songDetail['artistId']);
        Artist artist = Artist.fromjson(artistDetail);

        // get album
        Map albumDetail = await _idb.getOne('media', 'album', songDetail['albumId']);
        Album album = Album.fromjson(albumDetail, artist: artist);

        Song song = Song.fromjson(songDetail, isLocal: true, artist: artist, album:album);
        songs.add(song);
      },
      onDone: sortlist);
  }

  void sortlist() 
  {
    List<int> tempInts = [];
    songs.forEach((s) => tempInts.add(s.storedDate));
    tempInts.sort();

    List<Song> sortedSongs = [];
    tempInts.forEach((date) 
    {
      int index = songs.indexWhere((item) => item.storedDate == date);
      sortedSongs.add(songs[index]);
    });

    songs = sortedSongs;
  }

  Function removeSong(Map song, ButtonOptions options)
  {
    bool isConfirmed = window.confirm('Do you want to remove this item?');
    if(!isConfirmed) return null;

    options.doWaiting(true);

    Song s = Song.fromjson(song);
    _provider.removeDownloadedSong(s)
    .then((r) => songs.removeWhere((item) => (s.id == item.id) ?true:false))
    .catchError((e) {
      options.doWaiting(false);
      options.setActivation(true);
      options.setColor('red');
    });
  }
}
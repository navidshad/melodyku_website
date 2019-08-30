import 'package:angular/angular.dart';
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
class DownloadsPage 
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
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'downloads');

    actions = [
      ActionButton(title: 'delete', onEvent: removeSong),
    ];

    prepare();
  }

  void playAll() =>
    _playerService.playByList(songs);

  void prepare() async
  {
    songs = [];
    ObjectStore songColl = await _idb.getCollection('media', 'song');

    songColl.openCursor()
      .listen((CursorWithValue cursor) 
      {
        if(cursor != null) cursor.next();
        else return;

        Map songDetail =  validateFields(cursor.value, SystemSchema.song);
        Song song = Song.fromjson(songDetail, isLocal: true);
        songs.add(song);
      });
  }

  Function removeSong(Map song, ButtonOptions options)
  {
    bool isConfirmed = window.confirm('Do you want to remove this item?');
    if(!isConfirmed) return null;

    options.doWaiting(true);

    Song s = Song.fromjson(song);
    _provider.removeDownloadedSong(s)
    .then((r) => prepare())
    .catchError((e) {
      options.doWaiting(false);
      options.setActivation(true);
      options.setColor('red');
    });
  }
}
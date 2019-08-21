import 'package:angular/angular.dart';

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
    QuotaUsage,
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

  List<Song> songs = [];

  // constructor ==================================
  DownloadsPage(this._idb, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'downloads');

    prepare();
  }

  void prepare() async
  {
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
}
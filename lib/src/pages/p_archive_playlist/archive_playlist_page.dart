import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_playlist_page.html',
  styleUrls: [ 'archive_playlist_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionItemEditorComponent,
    TableSong,
  ]
)
class ArchivePlaylistPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;
  PlayerService _playerService;
  MongoDBService _mongodb;

  String playlistID;
  List<DbField> languages = [];
  CollectionOptions playlistEditorOptions;
  
  PlaylistEditor playlistEditor;
  List<ActionButton> actionButtons = [];
  
  // constructor ==================================
  ArchivePlaylistPage(this._playerService, this._mongodb, this._categoryService, this._messageService, this.lang, this._userservice)
  {
    actionButtons = [
      ActionButton(title:'remove', onEvent: removeSong)
    ];
  }

  @override
  void onActivate(_, RouterState current)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_playlist'
    );
    
    playlistID = current.parameters['_id'];

    prepareOptions();
    getPlaylist();
  }

  void prepareOptions() async
  {
    playlistEditorOptions = CollectionOptions(
      hasCover: true,
      title:"detail",
      database: "media",
      collection:"playlist",
      id:playlistID,
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.playlist, _categoryService.getGroups()),
    );
  }

  void getPlaylist()
  {
    Map query = { '_id':playlistID };
    Map options = {
      'populates': [ 
        {
          'path': 'list', 
          'populate': { 'path': 'artistId albumId' }
        } 
      ]
    };

    _mongodb.findOne(
      isLive: true, database:'media', collection:'playlist', 
      query:query, options: options)
      .then((doc) 
      {
        Map validated = validateFields(doc, SystemSchema.playlist_populateVer);
        playlistEditor = PlaylistEditor.fromMap(validated, listContainesSongs: true);
      });
  }

  void removeSong(Map doc, ButtonOptions options)
  {
    options.doWaiting(true);

    String id = doc['_id'];
    playlistEditor.removeById(id)
      .then((r) => playlistEditor.list.removeWhere((song) => song.id == id))
      .whenComplete(() => options.doWaiting(false));
  }

  void _catchError(Error) => print(Error);
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_mediaPack_page.html',
  styleUrls: [ 'archive_mediaPack_page.css' ],
  directives: [
    coreDirectives,
    DbCollectionItemEditorComponent,
    GridComponent,
  ]
)
class ArchiveMediaPackPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;
  PlayerService _playerService;
  MongoDBService _mongodb;

  String mediaPackId;
  String type;

  List<DbField> languages = [];
  CollectionOptions mediaPackEditorOptions;
  
  MediaPackEditor mediaPackEditor;
  List<ActionButton> actionButtons = [];
  
  // constructor ==================================
  ArchiveMediaPackPage(this._playerService, this._mongodb, this._categoryService, this._messageService, this.lang, this._userservice)
  {
    _page = Page(
      userService: _userservice,
      messageService: _messageService,
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_playlist'
    );

    actionButtons = [
      ActionButton(title:'remove', onEvent: removeItem)
    ];
  }

  @override
  void onActivate(_, RouterState current)
  {
    mediaPackId = current.parameters['_id'];
    type = current.parameters['type'];

    prepareOptions();
    getMediaPack();
  }

  void prepareOptions() async
  {
    mediaPackEditorOptions = CollectionOptions(
      hasCover: true,
      title:"detail",
      database: "media",
      collection:"media_pack",
      id:mediaPackId,
      dbFields: SystemSchema.injectSubfields('categories', SystemSchema.mediaPack, _categoryService.getGroups()),
    );
  }

  void getMediaPack()
  {
    Map query = { '_id':mediaPackId };
    Map options = {
      'populates': [ 
        {
          'path': 'list', 
          'populate': { 'path': 'artistId' }
        } 
      ]
    };

    _mongodb.findOne(
      isLive: true, database:'media', collection:'media_pack', 
      query:query, options: options)
      .then((doc) => prepareMediaPack(doc as Map));
  }

  void prepareMediaPack(Map doc)
  {
    List<DbField> dbFields;
    Map validated;

    if(type == 'artist'){
      dbFields = SystemSchema.injectSubfields('list', SystemSchema.mediaPack_populateVer, SystemSchema.artist);
      validated = validateFields(doc, dbFields);
      mediaPackEditor = MediaPackEditor<Artist>.fromMap(validated, listContainesMediaObjects: true);
    }
    else if(type == 'album'){
      dbFields = SystemSchema.injectSubfields('list', SystemSchema.mediaPack_populateVer, SystemSchema.album_populteVer);
      validated = validateFields(doc, dbFields);
      mediaPackEditor = MediaPackEditor<Album>.fromMap(validated, listContainesMediaObjects: true);
    }
    else if(type == 'playlist'){
      dbFields = SystemSchema.injectSubfields('list', SystemSchema.mediaPack_populateVer, SystemSchema.playlist);
      validated = validateFields(doc, dbFields);
      mediaPackEditor = MediaPackEditor<Playlist>.fromMap(validated, listContainesMediaObjects: true);
    }
  }

  List<Card> getCards()
  {
   List<Card> cards= [];

   mediaPackEditor.list.forEach((item) 
    => cards.add(item.getAsWidget<Card>()));

   return cards;
  }

  void removeItem(Map doc, ButtonOptions options)
  {
    options.doWaiting(true);

    String id = doc['_id'];
    mediaPackEditor.removeById(id)
      .then((r) => mediaPackEditor.list.removeWhere((song) => song.id == id))
      .whenComplete(() => options.doWaiting(false));
  }

  void _catchError(Error) => print(Error);
}
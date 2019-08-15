import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'page',
  templateUrl: 'category_page.html',
  styleUrls: [ 'category_page.css' ],
  directives: [
    coreDirectives,
    ListWideComponent,
    SliderRectComponent,
  ]
  )
class CategoryPage implements OnActivate
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  CategoryService _categoryService;
  ContentProvider _provider;

  String id;
  Map category;

  ResultWithNavigator<Song> topListNavigator;
  List<ListItem> songs = [];
  List<Card> albums = [];
  List<Card> artists = [];

  // constructor ==================================
  CategoryPage(this.lang, this._messageService, this._provider,
    this._userservice, this._categoryService)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService,
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'category',
    );
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    id = current.parameters['id'];
    prepare();
    setupPageTitle();
  }

  void setupPageTitle()
  {
    category = _categoryService.getCategoryById(id);
    if(category == null) return;

    String newTitle = getLocalValue(category['local_title'], lang.getCode());
    _page.title = newTitle;
    _page.updateTitleBar();
  }

  void prepare()
  {
    Map<String, dynamic> query = {'categories':id};

    // get songs
    _provider.mediaselector.playlist_getRamdom(
      'songs', query: query, total: 30) .then((playlist) 
    {
      songs = playlist.getChildsAsWidgets<ListItem>(total: 30);
    });

    // get albums
    _provider.mediaselector.album_getRandomList(query: query)
    .then((List<Album> r) 
    {
      r.forEach((item) {
        Card widget = item.getAsWidget<Card>();
        albums.add(widget);
      });
    });

    // get artists
    _provider.mediaselector.artist_getRandomList(query: query)
    .then((List<Artist> r) 
    {
      r.forEach((item) {
        Card widget = item.getAsWidget<Card>();
        artists.add(widget);
      });
    });
  }
}
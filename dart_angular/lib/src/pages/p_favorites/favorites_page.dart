import 'package:angular/angular.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../../class/page/page.dart';
import '../../class/classes.dart';

@Component(
  selector: 'page',
  templateUrl: 'favorites_page.html',
  styleUrls: [ 'favorites_page.css' ],
  directives: [
    ListWideComponent
  ],
  )
class FavoritesPage implements OnInit
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;
  List<ListItem> listItems_favorites;

  // constructor ==================================
  FavoritesPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: true,
      title: 'favorites');
  }

  // OnInit -
  void ngOnInit() => getItems();
  void getItems() async 
  {
    // get 
    Playlist pl_favorites = await _contentProvider.archive.favorites_getList();
    listItems_favorites = pl_favorites.getChildsAsWidgets<ListItem>(total: 50);
  }
}
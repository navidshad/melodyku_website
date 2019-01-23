import 'package:angular/angular.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../../class/classes.dart';
import '../../class/page/page.dart';
import '../../class/types.dart';

@Component(
  selector: 'page',
  templateUrl: 'vitrin_page.html',
  styleUrls: [ 'vitrin_page.scss.css' ],
  directives: [
    SliderRectComponent,
    ListWideComponent,
    GridComponent,
  ],
  )
class VitrinPage implements OnInit
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;
  List<Card> card_top10_month;
  List<Card> card_for_you;
  List<ListItem> listItems_top15_day;
  

// constructor ==================================
VitrinPage(this._contentProvider, this._messageService, this._userservice)
{
  _page = Page(
    userService: _userservice, 
    messageService: _messageService, 
    permissionType: PermissionType.freemium_access,
    needLogedIn: false,
    title: 'vitrin'
  );
}

// OnInit -
void ngOnInit() => getItems();
void getItems() async 
 {
    // get 
    String p_month_id = '5bfd635ccb6db178f4e4b14e';
    Playlist pl_top10_month = await _contentProvider.archive.playlist_getById(p_month_id);
    card_top10_month = pl_top10_month.getChildsAsWidgets<Card>(total: 10);

    // get forYou list
    String p_forYou_id = '5ba8f3018f5e0509f0b3d1cc';
    Playlist pl_for_you = await _contentProvider.archive.playlist_getById(p_forYou_id);
    card_for_you = pl_for_you.getChildsAsWidgets<Card>(total: 10);

    // get 15 top media of day
    String p_day_id = '5ba8a5cf31243004332bd45a';
    Playlist pl_top15_day = await _contentProvider.archive.playlist_getById(p_day_id);
    listItems_top15_day = pl_top15_day.getChildsAsWidgets<ListItem>(total: 15);
 }
}
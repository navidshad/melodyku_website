import 'package:angular/angular.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../../class/classes.dart';

@Component(
  selector: 'page',
  templateUrl: 'vitrin_page_component.html',
  styleUrls: [ 'vitrin_page_component.scss.css' ],
  directives: [
    SliderRectComponent,
    ListWideComponent,
    GridComponent,
  ],
  )
class VitrinPageComponent implements OnInit
{
  ContentProvider _contentProvider;
  List<Card> card_top10_month;
  List<Card> card_for_you;
  List<ListItem> listItems_top15_day;
  VitrinPageComponent(this._contentProvider);

  void ngOnInit() => getItems();

 void getItems() async 
 {
    // get 
    String p_month_name = '🎧 برترین های ماه ⭐️';
    Playlist pl_top10_month = await _contentProvider.archive.playlist_get(p_month_name);
    card_top10_month = pl_top10_month.getCardList(10);

    // get forYou list
    String p_forYou_name = '🎧 برترین های هفته ⭐️';
    Playlist pl_for_you = await _contentProvider.archive.playlist_get(p_forYou_name);
    card_for_you = pl_for_you.getCardList(10);

    // get 15 top media of day
    String p_day_name = '🎧 برترین های امروز ⭐️';
    Playlist pl_top15_day = await _contentProvider.archive.playlist_get(p_day_name);
    listItems_top15_day = pl_top15_day.getItemList(15);
 }
}
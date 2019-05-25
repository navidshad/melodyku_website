import 'package:angular/angular.dart';

import 'package:melodyku/src/widgets/widgets.dart';
import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/classes.dart';

@Component(
  selector:'list-wide',
  templateUrl: 'list_wide_component.html',
  styleUrls: ['list_wide_component.css'],
  directives: [ 
    coreDirectives,
    CardWideComponent,
    ]
)
class ListWideComponent
{
  LanguageService lang;
  PlayerService _playerService;

  int count = 15;

  ListWideComponent(this.lang, this._playerService);

  @Input()
  String title;
  
  @Input()
  bool numerical;

  @Input()
  List<ListItem> items;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  void playAll() {
    List<Song> list = [];
    items.forEach((card) => list.add(card.origin as Song));
    _playerService.playByList(list);
  }
}
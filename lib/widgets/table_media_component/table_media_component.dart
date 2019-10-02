/// {@nodoc}
library tableSongComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'table-media',
  templateUrl: 'table_media_component.html',
  styleUrls: ['table_media_component.css'],
  directives: [
    coreDirectives,
    MediaCoverComponent,
    ButtonRounded,
    DirectionDirective,
    ButtonDownloadSong,
    WidgetLoading,
    PopMenuComponent,
  ],
  exports: [
    getSongMenuItems,
    getSongMenuItemsCount,
  ]
)
class TableSong implements OnChanges
{
  PlayerService _playerService;
  Player _player;
  LanguageService lang;
  UserService _userService;
  
  String title = '';
  List<Song> list;

  TableSong(this.lang, this._playerService, this._player, this._userService);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if(navigator != null) navigator.onUpdated.listen((key) => list = navigator.list);
  }

  @Input('songNavigator')
  ResultWithNavigator<Song> navigator;

  @Input('songs')
  set setSongs(List<Song> value)
  {
    list = value;
  }

  @Input()
  bool hideMore;

  @Input()
  List<ActionButton> actionButtons = [];

  @Input()
  bool showPopupButtons = false;

  @Input()
  bool hideDownloadButton = false;

  int hoverNumber = -1;

  int get selectedNumber 
  {
    int selected = -1;
    for(int i =0; i < list.length; i++) {
      if(_player.current?.id == list[i].id) 
        selected = i;
    };

    return selected;
  }

  void getMore()
  {
    navigator.loadNextPage();
  }

  void play(int i) {
    _playerService.play(list[i]);
  }

  // when mose go into
  void onmouseenter(int i) => hoverNumber = i;
  // when mose go out from
  void onmouseleave() => hoverNumber = -1;

  bool get isLogedIn => _userService.isLogedIn;

  bool getAccessToShowMore()
  {
    bool key = true;

    if(hideMore != null) 
      key = !hideMore;

    return key;
  }

  ActionButton getCloneButton(ActionButton ab)
  {
    ActionButton newBtn = ActionButton(title: ab.title, onEvent: ab.onEvent);
    return newBtn;
  }
}
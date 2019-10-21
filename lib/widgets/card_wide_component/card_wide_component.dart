/// {@nodoc}
library cardWideComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/pips/pips.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.css'],
  directives: [
    coreDirectives,
    DirectionDirective,
    LikeComponent,
    MediaCoverComponent,
    ButtonDownloadSong,
    PopMenuComponent,
  ],
  pipes: [
    TitlePipe,
    UpFirstCharsPipe,
  ],
  exports: [
    getSongMenuItems,
    getSongMenuItemsCount,
  ]
)
class CardWideComponent 
{
  LanguageService lang;
  Player _player;
  PlayerService _playerService;
  UserService _userService;

  ButtonOptions downloadOptions;
  bool isDownloaded = false;

  int boxSize = 50;

  @Input()
  ListItem item;

  @Input()
  bool numerical;

  @Input()
  bool duration;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  @Input()
  int number;

  @Input()
  bool showPopupButtons = false;

  int hoverIndex = -1;

  int get selectedIndex {
    if(_player.current?.id == item.id)
      return number;
    else return -1;
    //return -1;
  }

  CardWideComponent(this.lang, this._playerService, this._player, this._userService);

  void play() {
    if(item.type == ArchiveTypes.song)
      _playerService.play(item.origin);
  }

  void like()
  {
    print('linking');
    item.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;

  // when mose go into
  void onmouseenter(int i) => hoverIndex = i;
  // when mose go out from
  void onmouseleave() => hoverIndex = -1;
}
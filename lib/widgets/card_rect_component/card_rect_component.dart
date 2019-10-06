/// {@nodoc}
library cardRectComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.css'],
  directives: [
    coreDirectives, 
    LikeComponent,
    MediaCoverComponent,
    PopMenuComponent,
  ],
  exports: [
    getMediaMenuItems,
    getMediaMenuItemsCount,
  ]
)
class CardRectComponent
{
  LanguageService lang;
  Player _player;
  UserService _userService;
  PlayerService _playerService;

  CardRectComponent(this.lang, this._playerService, this._player, this._userService);

  @Input()
  Card card;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  @Input()
  int number;

  @Input()
  bool couldliked;

  @Input()
  bool showPopupButtons = false;

  int hoverIndex = -1;

  int get selectedIndex {
    if(_player.current?.id == card.id)
      return number;
    else return -1;
    //return -1;
  }

  bool getArtistBeingStatus()
  {
    bool key = false;

    if(card != null && card.type == ArchiveTypes.artist)
      key = true;

    return key;
  }

  void play()
  {
    if(card.type == ArchiveTypes.song)
      _playerService.play(card.origin);
  }

  void like() => card.origin.like();

  bool get isLogedIn => _userService.isLogedIn;

  // when mose go into
  void onmouseenter(int i) => hoverIndex = i;
  // when mose go out from
  void onmouseleave() => hoverIndex = -1;
}
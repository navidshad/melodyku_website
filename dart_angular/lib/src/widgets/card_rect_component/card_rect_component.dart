import 'package:angular/angular.dart';
import '../../class/classes.dart';
import '../../services/services.dart';

import 'package:melodyku/src/widgets/like_component/like_component.dart';
import 'package:melodyku/src/widgets/media_cover/media_cover_component.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.scss.css'],
  directives: [
    coreDirectives, 
    //ItemMenuComponent
    LikeComponent,
    MediaCoverComponent,
  ],
)
class CardRectComponent
{
  Player _player;
  UserService _userService;
  PlayerService _playerService;

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

  int hoverIndex = -1;

  int get selectedIndex {
    if(_player.current?.id == card.id)
      return number;
    else return -1;
    //return -1;
  }

  CardRectComponent(this._playerService, this._player, this._userService);

  void play()
  {
    _playerService.play(StreamDetail_Player(true, card.type, card.origin));
  }

  void like()
  {
    card.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;

  // bool getPlayAccess() => playBtn ?? true;
  // bool getExploreAccess() => exploreBtn ?? false;

  // when mose go into
  void onmouseenter(int i) => hoverIndex = i;
  // when mose go out from
  void onmouseleave() => hoverIndex = -1;
}
import 'package:angular/angular.dart';

import '../../class/classes.dart';
import '../../services/services.dart';

import '../like_component/like_component.dart';
import '../cover_small/cover_small_component.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.scss.css'],
  directives: [
    coreDirectives,
    LikeComponent,
    CoverSmallComponent,
    ]
)
class CardWideComponent 
{
  Player _player;
  PlayerService _playerService;
  UserService _userService;

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

  int hoverIndex = -1;

  int get selectedIndex {
    if(_player.current?.id == item.id)
      return number;
    else return -1;
    //return -1;
  }

  CardWideComponent(this._playerService, this._player, this._userService);

  void play() {
    _playerService.play(StreamDetail_Player(true, item.type, item.origin));
  }

  void like()
  {
    item.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;

  // when mose go into
  void onmouseenter(int i) => hoverIndex = i;
  // when mose go out from
  void onmouseleave() => hoverIndex = -1;
}
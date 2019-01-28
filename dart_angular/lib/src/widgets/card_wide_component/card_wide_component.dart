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

  int selectedIndex = -1;
  int hoverIndex = -1;

  CardWideComponent(this._playerService, this._userService);

  void play() {
    selectedIndex = number;
    _playerService.play(StreamDetail_Player(true, item.type, item.origin));
  }

  void like()
  {
    item.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;

  // when mose go into
  void onmouseenter(int i) {
    print('onmouseenter');
    hoverIndex = i;
  }
  // when mose go out from
  void onmouseleave() => hoverIndex = -1;
}
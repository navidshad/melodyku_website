import 'package:angular/angular.dart';

import '../../class/classes.dart';
import '../../services/services.dart';

import '../like_component/like_component.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.scss.css'],
  directives: [
    coreDirectives,
    LikeComponent,
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

  CardWideComponent(this._playerService, this._userService);

  void play() => _playerService.play(StreamDetail_Player(true, item.type, item.origin));

    void like()
  {
    item.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;
}
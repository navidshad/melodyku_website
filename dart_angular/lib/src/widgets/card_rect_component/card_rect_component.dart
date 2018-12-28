import 'package:angular/angular.dart';
import '../../class/classes.dart';
import '../../services/services.dart';
import '../../services/user_service.dart';
import '../like_component/like_component.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.scss.css'],
  directives: [
    coreDirectives, 
    //ItemMenuComponent
    LikeComponent,
  ],
)
class CardRectComponent
{
  UserService _userService;
  PlayerService _playerService;

  @Input()
  Card card;

  CardRectComponent(this._playerService, this._userService);

  void play()
  {
    _playerService.play(StreamDetail_Player(true, card.type, card.origin));
  }

  void like()
  {
    card.origin.like();
  }

  bool get isLogedIn => _userService.isLogedIn;
}
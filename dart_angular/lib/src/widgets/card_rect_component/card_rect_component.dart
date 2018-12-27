import 'package:angular/angular.dart';
import '../../class/classes.dart';
import '../../services/services.dart';
import '../item_menu_component/ItemMenuComponent.dart';
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
  PlayerService _playerService;

  @Input()
  Card card;

  CardRectComponent(this._playerService);

  void play()
  {
    _playerService.play(StreamDetail_Player(true, card.type, card.origin));
  }

  void like()
  {
    card.origin.like();
  }
}
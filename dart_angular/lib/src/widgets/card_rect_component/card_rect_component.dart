import 'package:angular/angular.dart';
import '../../class/classes.dart';
import '../../services/services.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.scss.css'],
  directives: [coreDirectives],
)
class CardRectComponent
{
  PlayerService _playerService;

  @Input()
  Card card;

  CardRectComponent(this._playerService);

  void play()
  {
    _playerService.play(ModalPlayerDetail(true, card.type, card.origin));
  }
}
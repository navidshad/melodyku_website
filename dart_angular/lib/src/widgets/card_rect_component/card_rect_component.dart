import 'package:angular/angular.dart';
import '../../class/classes.dart';
import '../../services/modal_service.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.scss.css'],
  directives: [coreDirectives],
)
class CardRectComponent
{
  ModalService _modalService;

  @Input()
  Card card;

  CardRectComponent(this._modalService);

  void play()
  {
    _modalService.play(ModalPlayerDetail(true, card.type, card.origin));
  }
}
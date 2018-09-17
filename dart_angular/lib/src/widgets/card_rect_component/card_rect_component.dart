import 'package:angular/angular.dart';
import '../class/card.dart';

@Component(
  selector: 'card-rect',
  templateUrl: 'card_rect_component.html',
  styleUrls: ['card_rect_component.scss.css'],
  directives: [coreDirectives],
)
class CardRectComponent
{
  @Input()
  Card card;
}
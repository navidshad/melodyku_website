import 'package:angular/angular.dart';
import '../class/card.dart';

@Component(
  selector: 'grid-card',
  templateUrl: 'grid_card_component.html',
  styleUrls: ['grid_card_component.scss.css'],
  directives: [coreDirectives],
)
class GridCardComponent
{
  @Input()
  Card card;
}
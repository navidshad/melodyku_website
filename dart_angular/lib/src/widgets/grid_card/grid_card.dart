import 'package:angular/angular.dart';
import '../class/card.dart';

@Component(
  selector: 'grid-card',
  templateUrl: 'grid_card.html',
  styleUrls: ['grid_card.scss.css'],
  directives: [coreDirectives],
)
class GridCard 
{
  @Input()
  Card card;
}
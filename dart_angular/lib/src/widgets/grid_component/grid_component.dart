import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../class/classes.dart';

@Component(
  selector: 'grid-rect',
  templateUrl: 'grid_component.html',
  styleUrls: [ 'grid_component.scss.css' ],
  directives: [
    coreDirectives,
    CardRectComponent,
    ],
)
class GridComponent
{
  @Input()
  String title;

  @Input()
  bool masonry;

  @Input()
  List<Card> items;
}
/// {@nodoc}
library gridComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'grid-rect',
  templateUrl: 'grid_component.html',
  styleUrls: [ 'grid_component.css' ],
  directives: [
    coreDirectives,
    CardRectComponent,
    DirectionDirective,
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

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  @Input()
  bool couldliked;
}
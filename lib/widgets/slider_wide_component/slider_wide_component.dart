/// {@nodoc}
library sliderWideComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'slider-wide',
  templateUrl: 'slider_wide_component.html',
  styleUrls: ['slider_wide_component.css'],
  directives: [
    coreDirectives,
    CardWideComponent
  ]
)
class sliderWideComponent
{
  String title = '';
  int height = 250;
  int itemSize = 200;
  int move = 0;

  @Input()
  List<Card> items;

  @Input()
  bool couldliked;

  void next() => move += itemSize;
  void prev() => move -= itemSize;
  String moveSlider() => "translateX(${move}px)";
}
import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../class/classes.dart';

@Component(
  selector: 'slider-rect',
  templateUrl: 'slider_rect_component.html',
  styleUrls: [ 'slider_rect_component.scss.css' ],
  directives: [ 
    coreDirectives,
    CardRectComponent,
   ],
)
class SliderRectComponent
{
  int height = 250;
  int itemSize = 200;
  int move = 0;
  
  @Input()
  String title;

  @Input()
  List<Card> items;

  void next() => move += itemSize;
  void prev() => move -= itemSize;
  String moveSlider() => "translateX(${move}px)";
}
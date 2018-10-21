import 'package:angular/angular.dart';
import 'dart:html';

import '../widgets.dart';
import '../../class/classes.dart';
import '../../directives/directives.dart';

@Component(
  selector: 'slider-rect',
  templateUrl: 'slider_rect_component.html',
  styleUrls: [ 'slider_rect_component.scss.css' ],
  directives: [ 
    coreDirectives,
    CardRectComponent,
    ElementExtractorDirective
   ],
)
class SliderRectComponent
{
  Element slider;
  int height = 250;
  int itemSize = 210;
  
  @Input()
  String title;

  @Input()
  List<Card> items;

  void next() 
  {
    //move += itemSize;
    int currentPos = slider.scrollLeft;
    slider.scroll(currentPos - itemSize, 0);
  }

  void prev() 
  {
    //move -= itemSize;
    int currentPos = slider.scrollLeft;
    slider.scroll(currentPos + itemSize, 0);
  }

  void getSliderElement(Element el) => slider = el;
}
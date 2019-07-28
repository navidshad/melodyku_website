/// {@nodoc}
library sliderRectComponent;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
  selector: 'slider-rect',
  templateUrl: 'slider_rect_component.html',
  styleUrls: [ 'slider_rect_component.css' ],
  directives: [ 
    coreDirectives,
    CardRectComponent,
    ElementExtractorDirective,
   ],
)
class SliderRectComponent
{
  Element slider;
  int height = 250;
  int itemSize = 210;

  LanguageService lang;
  PlayerService _playerService;

  SliderRectComponent(this.lang, this._playerService);
  
  @Input()
  String title;

  @Input()
  List<Card> items;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  @Input()
  bool couldliked;

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

  void playAll() {
    List<Song> list = [];
    items.forEach((card) => list.add(card.origin as Song));
    _playerService.playByList(list);
  }
}
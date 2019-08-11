/// {@nodoc}
library sliderAdaptiveSizeComponent;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/swiper/swiper.dart';

@Component(
  selector: 'slider-adaptive_size',
  templateUrl: 'slider_adaptive_size_component.html',
  styleUrls: [ 'slider_adaptive_size_component.css' ],
  directives: [ 
    coreDirectives,
    DirectionDirective,
    CardFullsizeComponent,
    ElementExtractorDirective,
   ],
)
class SliderAdaptiveSizeComponent implements OnChanges
{
  Element slider;
  LanguageService lang;
  Swiper swiper;

  SliderAdaptiveSizeComponent(this.lang);

  @Input()
  List<Card> cards;

  @Input()
  int height;

  @Input()
  int width;

  bool initilized = false;

  @override
  ngOnChanges(Map<String, SimpleChange> changes) 
  {
    initSwiper();
  }

  void initSwiper() async
  {
    await Future.delayed(Duration(seconds:1));
    swiper = Swiper(
      '#${cards.hashCode}',
      createSwipeOptions(
        slidesPerView: 'auto',
        spaceBetween: 50,
        navigation: SwiperNavigation(
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',),
      )
    );

    initilized = true;
  }

  void getSliderElement(Element el) => slider = el;
}
/// {@nodoc}
library sliderRectComponent;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/swiper/swiper.dart';
import 'package:melodyku/pips/pips.dart';

@Component(
  selector: 'slider-rect',
  templateUrl: 'slider_rect_component.html',
  styleUrls: [ 'slider_rect_component.css' ],
  directives: [ 
    coreDirectives,
    WidgetLoading,
    DirectionDirective,
    CardRectComponent,
    ElementExtractorDirective,
   ],
   pipes: [
    TitlePipe,
   ]
)
class SliderRectComponent implements OnChanges
{
  Element slider;
  int height = 250;
  int itemSize = 210;

  LanguageService lang;
  PlayerService _playerService;

  Swiper swiper;

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
      '#${items.hashCode}',
      createSwipeOptions(
        slidesPerView: 'auto',
        spaceBetween: 10,
        centeredSlides: true,
        loop: true,
        navigation: SwiperNavigation(
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',),
        more: {
          // 'breakpoints': {
          //   // when window width is >= 320px
          //   320: {
          //     'slidesPerView': 3,
          //     //'spaceBetween': 20
          //   },
          //   420: {
          //     'slidesPerView': 3,
          //     'spaceBetween': 5
          //   },
          //   // when window width is >= 480px
          //   480: {
          //     'slidesPerView': 4,
          //     //'spaceBetween': 10
          //   },
          //   // when window width is >= 640px
          //   640: {
          //     'slidesPerView': 4,
          //     //'spaceBetween': 40
          //   }
          // }
        }
      )
    );

    initilized = true;
  }

  void getSliderElement(Element el) => slider = el;

  void playAll() {
    List<Song> list = [];
    items.forEach((card) => list.add(card.origin as Song));
    _playerService.playByList(list);
  }
}
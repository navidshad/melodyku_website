import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../mock_service.dart';

@Component(
  selector: 'thumb-slider',
  templateUrl: 'w_thumb_slider.html',
  styleUrls: [
    'w_thumb_slider.scss.css',
    'slider_item.scss.css'
    ],
  directives: [
    coreDirectives,
    ],
)
class ThumbSlider 
{
  String title = 'تازه ها';
  int height = 200;
  int boxSize = 128;
  int move = 0;

  ThumbSlider();

  List<SliderCard> items = mockSliderItems;

  void next() => move += boxSize;
  void prev() => move -= boxSize;

  String moveSlider() => "translateX(${move}px)";
}
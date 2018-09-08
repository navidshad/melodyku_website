import 'package:angular/angular.dart';

import 'slider_item.dart';

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

  List<SliderItem> items = mockSliderItems;

  void next() => move += boxSize;
  void prev() => move -= boxSize;

  String moveSlider() => "translateX(${move}px)";
}

int tWidth = 128;
int tHeight = 128;
List<SliderItem> mockSliderItems = [
  SliderItem('آیتم ' + "1", height: tHeight, width: tHeight, thumbnail: Uri(path: 'assets/imgs/512/sample (1).jpg')),
  SliderItem('آیتم ' + "2", height: tHeight, width: tHeight, thumbnail: Uri(path: 'assets/imgs/512/sample (2).jpg')),
  SliderItem('آیتم ' + "3", height: tHeight, width: tHeight, thumbnail: Uri(path: 'assets/imgs/512/sample (3).jpg')),
  SliderItem('آیتم ' + "4", height: tHeight, width: tHeight, thumbnail: Uri(path: 'assets/imgs/512/sample (4).jpg')),
  SliderItem('آیتم ' + "5", height: tHeight, width: tHeight, thumbnail: Uri(path: 'assets/imgs/512/sample (5).jpg')),
];
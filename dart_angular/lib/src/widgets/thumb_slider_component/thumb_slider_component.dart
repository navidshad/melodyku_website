import 'package:angular/angular.dart';
import 'dart:async';

import '../widgets.dart';
import '../../services/content_service.dart';

@Component(
  selector: 'thumb-slider',
  templateUrl: 'thumb_slider_component.html',
  styleUrls: [ 'thumb_slider_component.scss.css' ],
  directives: [ 
    coreDirectives,
    GridCardComponent,
   ],
)
class ThumbSliderComponent implements OnInit
{
  String title = 'تازه ها';
  int height = 250;
  int boxSize = 200;
  int move = 0;

  final ContentService _contentService;
  List<Card> items;

  ThumbSliderComponent(this._contentService);
  void ngOnInit() => _getItems();

  void next() => move += boxSize;
  void prev() => move -= boxSize;
  String moveSlider() => "translateX(${move}px)";

  Future<void> _getItems() async 
  {
    print('ThumbSlider: getting items');
    try {

      final List artists = await _contentService.getArtists();
      items = [];

      for (var i = 0; i < artists.length; i++) {
        var singer = artists[i];
        Card item = Card(singer['name'], thumbnail: Uri(path: singer['cover']));
        items.add(item);
      }

    } catch (e) {
      print(e);
    }
  }
}
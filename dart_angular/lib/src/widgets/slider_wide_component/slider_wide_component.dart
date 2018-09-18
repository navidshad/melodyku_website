import 'package:angular/angular.dart';
import 'dart:async';

import '../widgets.dart';
import '../../services/content_service.dart';

@Component(
  selector: 'slider-wide',
  templateUrl: 'slider_wide_component.html',
  styleUrls: ['slider_wide_component.scss'],
  directives: [
    coreDirectives,
    CardWideComponent
  ]
)
class sliderWideComponent implements OnInit
{
  String title = '';
  int height = 250;
  int itemSize = 200;
  int move = 0;

  final ContentService _contentService;
  List<Card> items;

  sliderWideComponent(this._contentService);
  void ngOnInit() => _getItems();

  void next() => move += itemSize;
  void prev() => move -= itemSize;
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
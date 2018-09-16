import 'dart:async';
import 'package:angular/angular.dart';

import '../../services/content_service.dart';
import '../widgets.dart';

@Component(
  selector: 'grid',
  templateUrl: 'grid.html',
  styleUrls: [ 'grid.scss.css' ],
  directives: [
    coreDirectives,
    GridCard,
    ],
)
class Grid implements OnInit
{
  @Input()
  String title;

  @Input()
  bool masonry;

  ContentService _contentService;
  List<Card> items;
  
  Grid(this._contentService);
  void ngOnInit() => _getItems();

  Future<void> _getItems() async
  {
    print('Grid: getting items');
    try {

      final List resultList = await _contentService.getArtists();
      items = [];

      for (var i = 0; i < resultList.length; i++) 
      {
        var singer = resultList[i];
        Card item = Card(
          singer['name'], 
          thumbnail: Uri(path: singer['cover'])
          );
        items.add(item);
      }

    } catch (e) {
      print(e);
    }
  }
}
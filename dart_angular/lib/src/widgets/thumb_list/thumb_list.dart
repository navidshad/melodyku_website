import 'dart:async';
import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../services/content_service.dart';
import '../../utility/math.dart';

@Component(
  selector:'thumb-list',
  templateUrl: 'thumb_list.html',
  styleUrls: ['thumb_list.scss.css'],
  directives: [ 
    coreDirectives,
    ListCardComponent,
    ]
)
class ThumbList implements OnInit 
{
  int boxSize = 60;
  int count = 15;

  @Input()
  String title;
  
  @Input()
  bool numerical;

  final ContentService _contentService;
  List<ListItem> items;

  ThumbList(this._contentService);
  void ngOnInit() => _getItems();

  Future<void> _getItems() async 
  {
    print('ThumbList: getting items');
    try {

      final List medias = await _contentService.getMedias();
      items = [];

      for (var i = 0; i < count; i++) {
        var media = medias[i];
        var tempNum = i+1;
        String number = (tempNum < 10) ? '0' + tempNum.toString() : tempNum.toString();
        
        ListItem item = ListItem(
          media['title'], 
          subtitle: media['albumartist'],
          thumbnail: Uri(path: media['cover']),
          number: number,
          length: randomRange(120, 560)
          );

        items.add(item);
      }

    } catch (e) {
      print(e);
    }
  }
}
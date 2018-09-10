import 'dart:async';
import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../services/content_service.dart';

@Component(
  selector:'thumb-list',
  templateUrl: 'thumb_list.html',
  styleUrls: ['thumb_list.scss.css'],
  directives: [ coreDirectives ]
)
class ThumbList implements OnInit 
{
  String title = 'ترانه های برتر';

  @Input()
  bool numerical;

  final ContentService _contentService;
  List<ThumbListItem> items;

  ThumbList(this._contentService);
  void ngOnInit() => _getItems();

  Future<void> _getItems() async 
  {
    print('ThumbList: getting items');
    try {

      final List medias = await _contentService.getMedias();
      items = [];

      for (var i = 0; i < medias.length; i++) {
        var media = medias[i];
        ThumbListItem item = ThumbListItem(
          media['title'], 
          subtitle: media['albumartist'],
          thumbnail: Uri(path: media['cover']),
          );
        items.add(item);
      }

    } catch (e) {
      print(e);
    }
  }
}
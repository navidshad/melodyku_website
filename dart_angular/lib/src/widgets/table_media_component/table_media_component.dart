import 'package:angular/angular.dart';

import '../../services/language_service.dart';
import '../widgets.dart';
import '../../class/classes.dart';

@Component(
  selector: 'table-media',
  templateUrl: 'table_media_component.html',
  styleUrls: ['table_media_component.scss.css'],
  directives: [
    coreDirectives,
  ]
)
class TableMedia
{
  LanguageService lang;
  String title = '';

  TableMedia(this.lang);

  @Input()
  List<Media> items;
}
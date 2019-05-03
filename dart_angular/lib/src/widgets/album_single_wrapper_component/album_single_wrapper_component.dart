import 'package:angular/angular.dart';
import 'dart:html';

import '../../services/language_service.dart';
import '../widgets.dart';
import '../../class/classes.dart';

import '../../widgets/table_media_component/table_media_component.dart';

@Component(
  selector: 'album-single-wrapper',
  templateUrl: 'album_single_wrapper_component.html',
  styleUrls: ['album_single_wrapper_component.css'],
  directives: [
    coreDirectives,
    TableSong
  ]
)
class AlbumSingleWrapperComponent
{
  LanguageService lang;

  AlbumSingleWrapperComponent(this.lang);

  @Input()
  String title;

  @Input()
  String subtitle;

  @Input()
  String detail;

  @Input()
  String thumbnail;

  @Input()
  List<Song> medias;
}
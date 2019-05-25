import 'package:angular/angular.dart';
import 'dart:html';

import '../../services/services.dart';
import '../widgets.dart';
import '../../class/classes.dart';

import '../../widgets/table_media_component/table_media_component.dart';
import 'package:melodyku/src/widgets/media_cover/media_cover_component.dart';

@Component(
  selector: 'album-single-wrapper',
  templateUrl: 'album_single_wrapper_component.html',
  styleUrls: ['album_single_wrapper_component.css'],
  directives: [
    coreDirectives,
    TableSong,
    MediaCoverComponent
  ]
)
class AlbumSingleWrapperComponent
{
  LanguageService lang;
  PlayerService _playerService;

  AlbumSingleWrapperComponent(this.lang, this._playerService);

  @Input()
  String title;

  @Input()
  String subtitle;

  @Input()
  String detail;

  @Input()
  String thumbnail;

  @Input()
  ResultWithNavigator<Song> songNavigator;

  void playAll() =>
    _playerService.playByList(songNavigator.list);

}
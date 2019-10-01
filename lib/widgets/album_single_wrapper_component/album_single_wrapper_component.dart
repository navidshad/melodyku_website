/// {@nodoc}
library albumSingleWrapperComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'album-single-wrapper',
  templateUrl: 'album_single_wrapper_component.html',
  styleUrls: ['album_single_wrapper_component.css'],
  directives: [
    coreDirectives,
    TableSong,
    MediaCoverComponent,
    PopMenuComponent,
    DirectionDirective,
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
  String subtitle_link;

  @Input()
  String detail;

  @Input()
  String thumbnail;

  @Input()
  ResultWithNavigator<Song> songNavigator;

  @Input()
  List<Song> songs;

  void playAll() =>
    _playerService.playByList(songNavigator.list);

}
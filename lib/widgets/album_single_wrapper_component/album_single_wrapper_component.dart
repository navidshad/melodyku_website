/// {@nodoc}
library albumSingleWrapperComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/pips/pips.dart';

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
    AdvertisementPresentor,
  ],
  pipes: [
    UpFirstCharsPipe
  ],
  exports: [
    getSingleAlbumMenuItems,
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
  bool isArtist = false;

  @Input()
  ResultWithNavigator<Song> songNavigator;

  @Input()
  List<Song> songs;

  void playAll() 
  {
    if(songNavigator != null) _playerService.playByList(songNavigator.list);
    else if(songs != null) _playerService.playByList(songs);
  }
}
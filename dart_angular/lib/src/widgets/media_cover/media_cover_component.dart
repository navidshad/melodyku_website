import 'dart:async';
import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/archive/song.dart';

@Component(
  selector: 'media-cover',
  templateUrl: 'media_cover_component.html',
  styleUrls: [ 'media_cover_component.css' ],
  directives: [
    coreDirectives,
  ]
)
class MediaCoverComponent 
{
  @Input()
  String lable;
  
  @Input()
  String thumbnail;

  @Input()
  String titleLink;

  @Input()
  int number;

  @Input()
  int selectedIndex;

  @Input()
  int hoverIndex;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;

  @Input()
  bool isBig;

  bool getPlayAccess() => playBtn ?? true;
  bool getExploreAccess() => exploreBtn ?? false;
}
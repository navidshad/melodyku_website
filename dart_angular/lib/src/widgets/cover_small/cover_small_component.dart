import 'dart:async';
import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/archive/media.dart';

@Component(
  selector: 'cover-small',
  templateUrl: 'cover_small_component.html',
  styleUrls: [ 'cover_small_component.scss.css' ],
  directives: [
    coreDirectives,
  ]
)
class CoverSmallComponent 
{
  @Input()
  String id;

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

  bool getPlayAccess() {
    print('number $number | selectedIndex $selectedIndex');
    return playBtn ?? true;
  } 
  bool getExploreAccess() => exploreBtn ?? false;
}
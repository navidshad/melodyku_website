/// {@nodoc}
library mediaCoverComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

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
  ContentProvider _contentProvider;

  MediaCoverComponent(this._contentProvider)
  {
    randomColor = getRandomColor();
    randomPattern = _contentProvider.getRandomPatterns();
  }

  String randomColor;
  String randomPattern;

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
  bool getCoverAccess() {
    //print('cover thumbnail ${thumbnail}');
    return (thumbnail != null && thumbnail.length > 10) ? true : false;
  }

  void explore()
  {
    if(!getExploreAccess()) return;

    print(titleLink);
    Navigator.goToRawPath(titleLink);
  }
}
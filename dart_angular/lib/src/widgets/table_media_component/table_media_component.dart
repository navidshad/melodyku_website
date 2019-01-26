import 'dart:async';
import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../services/language_service.dart';

import '../cover_small/cover_small_component.dart';
import '../../class/classes.dart';

@Component(
  selector: 'table-media',
  templateUrl: 'table_media_component.html',
  styleUrls: ['table_media_component.scss.css'],
  directives: [
    coreDirectives,
    CoverSmallComponent,
  ]
)
class TableMedia
{
  PlayerService _playerService;
  LanguageService lang;
  String title = '';

  TableMedia(this.lang, this._playerService);

  @Input()
  List<Media> items;

  int selectedNumber = -1;
  int hoverNumber = -1;

  void play(int i) {
    _playerService.play(StreamDetail_Player(true, items[i].type, items[i]));
    selectedNumber = i;
  }

  // when mose go into
  void onmouseenter(int i) {
    print('onmouseenter');
    hoverNumber = i;
  }
  // when mose go out from
  void onmouseleave() => hoverNumber = -1;
}
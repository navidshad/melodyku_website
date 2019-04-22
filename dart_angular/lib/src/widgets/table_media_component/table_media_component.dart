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
class TableSong
{
  PlayerService _playerService;
  Player _player;
  LanguageService lang;
  String title = '';

  TableSong(this.lang, this._playerService, this._player);

  @Input()
  List<Song> items;

  int hoverNumber = -1;

  int get selectedNumber {
    int selected = -1;
    for(int i =0; i < items.length; i++) {
      if(_player.current?.id == items[i].id) 
        selected = i;
    };

    return selected;
  }

  void play(int i) {
    _playerService.play(StreamDetail_Player(true, items[i].type, items[i]));
  }

  // when mose go into
  void onmouseenter(int i) {
    print('onmouseenter');
    hoverNumber = i;
  }
  // when mose go out from
  void onmouseleave() => hoverNumber = -1;
}
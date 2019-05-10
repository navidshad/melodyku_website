import 'dart:async';
import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../services/language_service.dart';

import 'package:melodyku/src/widgets/media_cover/media_cover_component.dart';
import '../../class/classes.dart';

@Component(
  selector: 'table-media',
  templateUrl: 'table_media_component.html',
  styleUrls: ['table_media_component.css'],
  directives: [
    coreDirectives,
    MediaCoverComponent,
  ]
)
class TableSong
{
  PlayerService _playerService;
  Player _player;
  LanguageService lang;
  String title = '';

  TableSong(this.lang, this._playerService, this._player);

  @Input('songNavigator')
  ResultWithNavigator<Song> navigator;

  int hoverNumber = -1;

  int get selectedNumber {
    int selected = -1;
    for(int i =0; i < navigator.list.length; i++) {
      if(_player.current?.id == navigator.list[i].id) 
        selected = i;
    };

    return selected;
  }

  void play(int i) {
    _playerService.play(StreamDetail_Player(true, navigator.list[i].type, navigator.list[i]));
  }

  // when mose go into
  void onmouseenter(int i) => hoverNumber = i;
  // when mose go out from
  void onmouseleave() => hoverNumber = -1;
}
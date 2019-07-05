/// {@nodoc}
library tableSongComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

import 'package:melodyku/stitch_cloner/stitch_cloner.dart' as SC;

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
  SC.ResultWithNavigator<Song> navigator;

  @Input()
  bool hideMore;

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
    _playerService.play(navigator.list[i]);
  }

  // when mose go into
  void onmouseenter(int i) => hoverNumber = i;
  // when mose go out from
  void onmouseleave() => hoverNumber = -1;

  bool getAccessToShowMore()
  {
    bool key = true;

    if(hideMore != null) 
      key = !hideMore;

    return key;
  }
}
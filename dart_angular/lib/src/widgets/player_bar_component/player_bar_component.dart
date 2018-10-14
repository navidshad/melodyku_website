import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';

import '../../services/services.dart';
import '../../class/classes.dart';
import '../../directives/directives.dart';

@Component(
  selector: 'player-bar',
  directives: [
    coreDirectives,
    MaterialSliderComponent,
    AudioSourceDirective,
  ],
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.scss.css'],
)
class PlayerBareComponent implements OnInit
{
  PlayerService _playerService;
  Player player;

  bool visible = true;

  double value = 60.0;

  PlayerBareComponent(this._playerService, this.player);
  void ngOnInit() => addListeners();

  void addListeners()
  {
    _playerService.modalStream.listen((ModalPlayerDetail detail)
    {
      visible = detail.visible;
      print('type : ${detail.type} | object: ${detail.object}');
      
      if(detail.type == ArchiveTypes.media) {
        print('playing media');
        player.setCurrent(Media.fromjson(detail.object));
      }
    });
  }

  void getAudioSource(AudioElement ac) => player.audio = ac;

  // calculated variables
  Media get current => player.current;
}


import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';

import '../../services/services.dart';
import '../../class/classes.dart';
import '../../directives/directives.dart';
import '../../pips/pips.dart';

@Component(
  selector: 'player-bar',
  directives: [
    coreDirectives,
    MaterialSliderComponent,
    ElementExtractorDirective,
  ],
  pipes: [DurationToString],
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.scss.css'],
)
class PlayerBareComponent implements OnInit
{
  bool visible = true;
  PlayerService _playerService;
  Player player;

  // controller buttons
  ImageButton nextBtn;
  ImageButton previousBtn;
  ImageButton repeatBtn;
  ImageButton shuffleBtn;

  PlayerBareComponent(this._playerService, this.player);
  void ngOnInit() => addListeners();

  void addListeners()
  {
    _playerService.modalStream.listen((ModalPlayerDetail detail)
    {
      visible = detail.visible;
      print('type : ${detail.type} | object: ${detail.object}');
      
      if(detail.type == ArchiveTypes.media) 
      {
        print('playing media');
        player.playTrack(Media.fromjson(detail.object));
      }
    });
  }

  void getElement(Element el)
  {
    String type = el.attributes['id'];
    switch (type) 
    {
      case 'next':
        nextBtn = ImageButton(
          el as ImageElement, 
          ClickType.trigger, 
          '/assets/svg/icon_next.svg', 
          '/assets/svg/icon_next_selected.svg',
          player.next);
        break;

      case 'previous':
        previousBtn = ImageButton(
          el as ImageElement, 
          ClickType.trigger, 
          '/assets/svg/icon_next.svg', 
          '/assets/svg/icon_next_selected.svg',
          player.previous);
        break;

      case 'play':
        player.playBtn = ImageButton(
          el as ImageElement, 
          ClickType.switchable, 
          '/assets/svg/icon_play.svg', 
          '/assets/svg/icon_pause.svg',
          player.play);
        break;

      case 'repeat':
        repeatBtn = ImageButton(
          el as ImageElement, 
          ClickType.switchable, 
          '/assets/svg/icon_repeat.svg', 
          '/assets/svg/icon_repeat_selected.svg',
          player.repeat);
        break;

      case 'shuffle':
        shuffleBtn = ImageButton(
          el as ImageElement, 
          ClickType.switchable, 
          '/assets/svg/icon_shuffle.svg', 
          '/assets/svg/icon_shuffle_selected.svg',
          player.shuffle);
        break;

      case 'audio':
        player.audio = el as AudioElement;
        break;
    }
  }

  // calculated variables
  Media get current => player.current;
}


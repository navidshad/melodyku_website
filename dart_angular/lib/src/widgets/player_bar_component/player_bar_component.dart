import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';

import '../../services/services.dart';
import '../../class/classes.dart';
import '../widgets.dart';
import '../../directives/directives.dart';
import '../../pips/pips.dart';


@Component(
  selector: 'player-bar',
  directives: [
    coreDirectives,
    MaterialSliderComponent,
    ElementExtractorDirective,
    CardWideComponent,
  ],
  pipes: [DurationToString],
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.css'],
)
class PlayerBareComponent
{
  bool isVisible = true;
  bool isQueueVisible = false;
  //PlayerService _playerService;
  LanguageService lang;
  SubscriptionService _subscriptionService;
  Player player;

  // controller buttons
  ImageButton nextBtn;
  ImageButton previousBtn;
  ImageButton repeatBtn;
  ImageButton shuffleBtn;

  // calculated variables
  Song get current => player.current;
  

  PlayerBareComponent(this.player, this.lang, this._subscriptionService)
  {
    player.audio = AudioElement();
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

  // queue metods
  void SwitchQueue() => isQueueVisible = !isQueueVisible;

  String getQueueClass() => 
    (isQueueVisible) ? 'queue-container queue-swipup' : 'queue-container queue-swipdown';

  String isitCurrentPlaying(id) => (player.current?.id == id) ? 'queue-current' : '';

  void buy() =>
    _subscriptionService.goToSubscriptionPage();

  bool isNeedWarning()
  {
    if(player.version == 'demo' && player.isPlaying) return true;
    else return false;
  }
}


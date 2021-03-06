/// {@nodoc}
library playerBarComponent;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/pips/pips.dart';


@Component(
  selector: 'player-bar',
  directives: [
    coreDirectives,
    MaterialSliderComponent,
    ElementExtractorDirective,
    CardWideComponent,
  ],
  pipes: [
    DurationToString,
    UpFirstCharsPipe,
  ],
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.css'],
)
class PlayerBareComponent
{
  LanguageService lang;
  AnalyticService _analytic;
  SubscriptionService _subscriptionService;
  UserService _userService;
  Player player;

  bool isVisible = true;
  bool isQueueVisible = false;

  // controller buttons
  ImageButton nextBtn;
  ImageButton previousBtn;
  ImageButton repeatBtn;
  ImageButton shuffleBtn;

  // calculated variables
  Song get current => player.current;
  

  PlayerBareComponent(this.player, this.lang, this._subscriptionService, this._userService, this._analytic)
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
  void SwitchQueue() {
    _analytic.trackEvent('switch player queue', category: 'player');
    isQueueVisible = !isQueueVisible;
  }

  String getQueueClass() => 
    (isQueueVisible) ? 'queue-container queue-swipup' : 'queue-container queue-swipdown';

  String isitCurrentPlaying(id) => (player.current?.id == id) ? 'queue-current' : '';

  void buy() {
    _analytic.trackEvent('goto subscription', category: 'player');
    _subscriptionService.goToSubscriptionPage();
  }

  void login() {
    _analytic.trackEvent('goto login', category: 'player');
    Navigator.gotTo('login', parameters:{'form':'login'});
  }

  bool getLoginStatus()
    => _userService.isLogedIn;

  bool isNeedWarning()
  {
    if(player.version == 'demo' && player.isPlaying) return true;
    else return false;
  }
}


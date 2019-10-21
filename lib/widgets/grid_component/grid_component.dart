/// {@nodoc}
library gridComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/pips/pips.dart';

@Component(
  selector: 'grid-rect',
  templateUrl: 'grid_component.html',
  styleUrls: [ 'grid_component.css' ],
  directives: [
    coreDirectives,
    CardRectComponent,
    DirectionDirective,
    WidgetLoading,
    ButtonRounded,
  ],
  pipes: [
    TitlePip,
   ]
)
class GridComponent
{
  LanguageService lang;

  GridComponent(this.lang);

  @Input()
  String title;

  @Input()
  List<Card> items = [];

  @Input()
  bool exploreBtn = false;

  @Input()
  bool playBtn = false;

  @Input()
  bool couldliked = false;

  @Input()
  List<ActionButton> actionButtons = [];

  ActionButton getCloneButton(ActionButton ab)
  {
    ActionButton newBtn = ActionButton(title: ab.title, onEvent: ab.onEvent);
    return newBtn;
  }
}
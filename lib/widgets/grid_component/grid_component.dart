/// {@nodoc}
library gridComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

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

  
  // List<ActionButton> actionButtons = [
  //     ActionButton(title:'remove')
  //   ];

  // ActionButton getCloneButton(ActionButton ab)
  // {
  //   print('getCloneButton');
  //   ActionButton newBtn = ActionButton(title: ab.title, onEvent: ab.onEvent);
  //   return newBtn;
  // }
}
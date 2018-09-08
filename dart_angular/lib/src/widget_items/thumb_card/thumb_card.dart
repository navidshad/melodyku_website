import 'package:angular/angular.dart';

import 'slider_card.dart';

@Component(
  selector: 'thumb-card',
  templateUrl: 'thumb_card.html',
  styleUrls: [
    'thumb_card.scss.css'
    ],
  directives: [coreDirectives],
)
class thumbCart 
{
  @Input()
  SliderCard card;
}
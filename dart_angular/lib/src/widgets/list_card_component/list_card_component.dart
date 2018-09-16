import 'package:angular/angular.dart';

import '../class/list_item.dart';

@Component(
  selector: 'list-card',
  templateUrl: 'list_card_component.html',
  styleUrls: ['list_card_component.scss.css'],
  directives: [coreDirectives]
)
class ListCardComponent 
{
  @Input()
  ListItem item;

  @Input()
  bool numerical;

  @Input()
  int boxSize;
}
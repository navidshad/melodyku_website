import 'package:angular/angular.dart';

import '../class/list_item.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.scss.css'],
  directives: [coreDirectives]
)
class CardWideComponent 
{
  @Input()
  ListItem item;

  @Input()
  bool numerical;

  @Input()
  int boxSize;
}
import 'package:angular/angular.dart';

import '../widgets.dart';
import '../../class/classes.dart';

@Component(
  selector:'list-wide',
  templateUrl: 'list_wide_component.html',
  styleUrls: ['list_wide_component.css'],
  directives: [ 
    coreDirectives,
    CardWideComponent,
    ]
)
class ListWideComponent
{
  int count = 15;

  @Input()
  String title;
  
  @Input()
  bool numerical;

  @Input()
  List<ListItem> items;

  @Input()
  bool exploreBtn;

  @Input()
  bool playBtn;
}
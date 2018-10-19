import 'package:angular/angular.dart';

import '../../class/classes.dart';
import '../../services/services.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.scss.css'],
  directives: [coreDirectives]
)
class CardWideComponent 
{
  PlayerService _playerService;
  int boxSize = 50;

  @Input()
  ListItem item;

  @Input()
  bool numerical;

  @Input()
  bool duration;

  CardWideComponent(this._playerService);

  void play() => _playerService.play(ModalPlayerDetail(true, item.type, item.origin));
}
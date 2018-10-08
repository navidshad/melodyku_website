import 'package:angular/angular.dart';

import '../../class/classes.dart';
import '../../services/modal_service.dart';

@Component(
  selector: 'card-wide',
  templateUrl: 'card_wide_component.html',
  styleUrls: ['card_wide_component.scss.css'],
  directives: [coreDirectives]
)
class CardWideComponent 
{
  ModalService _modalService;

  @Input()
  ListItem item;

  @Input()
  bool numerical;

  @Input()
  int boxSize;

  CardWideComponent(this._modalService);

  void play()
  {
    _modalService.play(ModalPlayerDetail(true, item.type, item.origin));
  }
}
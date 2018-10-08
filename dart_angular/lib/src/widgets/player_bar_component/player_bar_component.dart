import 'package:angular/angular.dart';
import '../../services/services.dart';
import '../../class/classes.dart';

@Component(
  selector: 'player-bar',
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.scss.css'],
  directives: [coreDirectives]
)
class PlayerBareComponent implements OnInit
{
  ModalService _modalService;
  ModalType type = ModalType.player;
  bool visible = true;

  Media current;

  PlayerBareComponent(this._modalService);
  void ngOnInit() => addListeners();

  void addListeners()
  {
    _modalService.modalStream.listen((ModalDetail detail)
    {
      if(detail.type != type) return;

      visible = detail.visible;
      current = Media.fromjson(detail.object);
    });
  }
}
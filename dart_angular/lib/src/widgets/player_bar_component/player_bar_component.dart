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
  bool visible = true;

  Media current;

  PlayerBareComponent(this._modalService);
  void ngOnInit() => addListeners();

  void addListeners()
  {
    _modalService.modalPlayerStream.listen((ModalPlayerDetail detail)
    {
      visible = detail.visible;
      print('type : ${detail.type} | object: ${detail.object}');
      
      if(detail.type == ArchiveTypes.media) {
        print('playing media');
        current = Media.fromjson(detail.object);
      }
    });
  }
}
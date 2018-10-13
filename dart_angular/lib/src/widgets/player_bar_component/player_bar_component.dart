import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';

import '../../services/services.dart';
import '../../class/classes.dart';

@Component(
  selector: 'player-bar',
  directives: [
    MaterialSliderComponent,
    coreDirectives,
  ],
  templateUrl: 'player_bar_component.html',
  styleUrls: ['player_bar_component.scss.css'],
)
class PlayerBareComponent implements OnInit
{
  ModalService _modalService;
  bool visible = true;
  
  double value = 60.0;
  double value2 = 0.5;

  Media current;

  PlayerBareComponent(this._modalService);
  void ngOnInit() => addListeners();

  void addListeners()
  {
    // _modalService.modalPlayerStream.listen((ModalPlayerDetail detail)
    // {
    //   visible = detail.visible;
    //   print('type : ${detail.type} | object: ${detail.object}');
      
    //   if(detail.type == ArchiveTypes.media) {
    //     print('playing media');
    //     current = Media.fromjson(detail.object);
    //   }
    // });
  }
}
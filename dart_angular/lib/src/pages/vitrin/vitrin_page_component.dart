import 'package:angular/angular.dart';
import '../../widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'vitrin_page_component.html',
  styleUrls: const [
    'vitrin_page_component.scss.css',
  ],
  directives: [
    ThumbSlider,
    ThumbList,
  ],
  )
class VitrinPageComponent 
{
  
}
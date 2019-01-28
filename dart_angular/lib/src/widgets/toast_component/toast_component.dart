import 'package:angular/angular.dart';

import '../../services/message_service.dart';

@Component(
  selector: 'toast',
  templateUrl: 'toast_component.html',
  styleUrls: ['toast_component.scss.css'],
  directives: [coreDirectives],
)
class ToastComponent {

  List<Map<String, String>> list = [];

}
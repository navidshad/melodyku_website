import 'package:angular/angular.dart';
import '../../services/app_shell_service.dart';
import '../../class/classes.dart';

@Component(
  selector: 'header-bar',
  templateUrl: 'header_menu.html',
  styleUrls: const [
    'header_menu.scss.css'
  ],

  directives: [
    coreDirectives
  ]
)
class HeaderMenu
{
  AppShellService _shellService;
  HeaderMenu(this._shellService);

  String title = 'رسانه موسیقی ملودیکو';
  String register = 'ثبت نام';
  String login = 'ورود';

  @Input()
  bool isMenuOpen;

  void switchMenu()
  {
    var sDetails = new StreamDetail_Common(!isMenuOpen, StreamType.sideMenu);
    _shellService.show(sDetails);
  }
}
import 'package:angular/angular.dart';

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
  String title = 'رسانه موسیقی ملودیکو';
  String register = 'ثبت نام';
  String login = 'ورود';
}
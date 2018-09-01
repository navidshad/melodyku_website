import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
  selector: 'header-menu',
  templateUrl: 'header_menu.html',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'header_menu.scss.css'
  ],

  directives: [
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialIconComponent,
  ],
  )
class HeaderMenu 
{
  String title = 'ملودیکو';
  String register = 'ثبت نام';
  String login = 'ورود';

  @Input('menuDrawer')
  MaterialPersistentDrawerDirective drawer;
}
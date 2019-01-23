import 'package:angular_router/angular_router.dart';
import '../types.dart';
import '../widgets/menu_item.dart';

import '../../services/language_service.dart';
import '../injector.dart' as CI;


class PageDefinition
{
  LanguageService _lang;
  RouteDefinition route;
  PermissionType permissionType;
  MenuPosition position;
  String iconImgRef;
  String title;

  PageDefinition
    ({this.route, this.permissionType, this.position, this.iconImgRef, this.title})
    {
      _lang = CI.Injector.get<LanguageService>();
    }

  MenuItem toMenuItem() {
    String tUrl = route != null ? route.toUrl() : "#";
    String localTitle = _lang.getStr(title);
    //print('title: $title | localTitle: $localTitle');
    return MenuItem(title: localTitle, img_ref: iconImgRef, url: tUrl);
  }
}
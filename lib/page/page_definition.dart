/// {@nodoc}
library pageDefinition;

import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';


class PageDefinition
{
  LanguageService _lang;
  RouteDefinition route;
  PermissionType permissionType;
  MenuPosition position;
  String iconImgRef;
  String title;

  PageDefinition
    ({this.route, this.permissionType, this.position, this.iconImgRef, this.title});

  MenuItem toMenuItem() 
  {
    String tUrl = route.toUrl();

    //String localTitle = _lang.getStr(title);
    MenuItem mi = MenuItem(title: title, img_ref: iconImgRef, url: tUrl);
    return mi;
  }
}
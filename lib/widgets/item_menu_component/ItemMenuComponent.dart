/// {@nodoc}
library itemMenuComponent;

import 'package:angular/angular.dart';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

@Component(
  selector: 'item-menu', 
  templateUrl: 'item_menu_component.html',
  styleUrls: ['item_menu_component.css']
)
class ItemMenuComponent
{
  LanguageService _lang;
  bool isShowMenu = false;
  StreamController<ItemMenuAction> controller;

  // List items = [
  //   {
  //     "icon":'/assets/',
  //     'title':'addToFavourites'
  //   },
  //   {
  //     "icon":'',
  //     'title':'share'
  //   }
  // ];

  ItemMenuComponent(this._lang);

  @Output('onClick')
  Stream get click => controller.stream;

  void switchMenu()
  {
    isShowMenu = !isShowMenu;
  }

  
}
/// {@nodoc}
library translateBtnComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'translate-btn',
  templateUrl: 'translate_btn_component.html',
  styleUrls: ['translate_btn_component.css'],
  directives: [
    coreDirectives, 
    formDirectives,
    ElementExtractorDirective,
  ],
)
class TranslateBtnComponent 
{
  ModalService _modalService;
  LanguageService lang;
  Modal modal;
  String selected;

  // contruction ================================
  TranslateBtnComponent(this._modalService, this.lang);

  void getModal(Element el)
  {
    modal = Modal(el);
    _modalService.register('languageSelection', modal);
  }

  // methods ====================================
  bool isCurrentLanguage(int i) => i == lang.current ? true : false;
  void switchTo(int i) => lang.switchTo(i);
}
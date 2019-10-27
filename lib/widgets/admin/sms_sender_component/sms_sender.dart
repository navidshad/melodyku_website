import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/swiper/swiper.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'sms-sender',
  templateUrl: 'sms_sender.html',
  styleUrls: ['sms_sender.css'],
  directives: [
    coreDirectives,
    formDirectives,
    SelectField,
    ButtonRounded,
    ElementExtractorDirective,
  ]
)
class SMSSenderComponent
{
  SMSService _smsService;
  SectionSwitcher swicher;

  String sendMethod = 'simple_sms';
  bool isCustomReceptors = false;
  String customReceptors = '';
  ButtonOptions sendButton;

  String template;
  String token;
  String token2;
  String token3;
  String message;

  List<DbField> sendMethods = [
    DbField('varification_sms', customTitle: 'varification sms'),
    DbField('varification_call', customTitle: 'varification call'),
    DbField('simple_sms', customTitle: 'simple sms'),
  ];

  @Input()
  List<String> receptors = [];

  SMSSenderComponent(this._smsService)
  {
    sendButton = ButtonOptions(
      lable: 'send', 
      type: ButtonType.sl,
      callback: prepare);
  }

  void onExtractElement(Element el)
  {
    swicher = SectionSwitcher([
      el.querySelector('#settings'),
      el.querySelector('#statistic'),
    ], showFirst: 'settings');
  }

  List<String> getCustomReceptors()
  {
    List<String> list  = [];

    customReceptors.split('\n')
      .forEach((part){
        int phone = int.tryParse(part);
        if(phone != null) list.add(part);
      });

    return list;
  }

  int getReceptorsCount()
  {
    int total = 0;

    if(!isCustomReceptors) total = receptors.length;
    else total = getCustomReceptors().length;

    return total;
  }

  Future<dynamic> send(String phone)
  {
    switch(sendMethod)
    {
      case 'varification_sms':
        return _smsService.lookup(phone, template, 
          messageType: 'sms',
          token: token,
          token2: token2,
          token3: token3);
        break;
      
      case 'varification_call':
        return _smsService.lookup(phone, template, 
          messageType: 'call',
          token: token,
          token2: token2,
          token3: token3);
        break;
      
      case 'simple_sms':
        return _smsService.sendSMS(phone, message);
        break;
    }
  }

  Function prepare(ButtonOptions op)
  { 
    op.doWaiting(true);
    swicher.show('swicher');

    Future.wait([
      Future(() async
      {

        List<String> receptorList = [];

        if(isCustomReceptors) receptorList = getCustomReceptors();
        else receptorList = receptors;

        for (var i = 0; i < receptorList.length; i++) {
          String receptor = receptorList[i];
          await send(receptor);
        }

      })
    ]).whenComplete((){
      op.doWaiting(false);
      swicher.show('settings');
    });
  }
}
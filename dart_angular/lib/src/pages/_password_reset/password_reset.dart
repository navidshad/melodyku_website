import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:html';
import 'dart:async';

import '../../services/services.dart';
import '../../services/stitch_service.dart';
import '../../services/modal_service.dart';

import '../../class/page/page.dart';
import '../../class/types.dart';

import '../../directives/ElementExtractorDirective.dart';

@Component(
  selector: 'page',
  templateUrl: 'password_reset.html',
  styleUrls: [ 'password_reset.css' ],
  directives: [
    coreDirectives,
    ElementExtractorDirective,
    formDirectives,
  ]
)
class PasswordResetPage implements OnActivate 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  StitchService _stitch;

  ModalService _modalService;
  Modal modal;

  String newPass;
  String token;
  String tokenID;

  // constructor ==================================
  PasswordResetPage(this._messageService, this._userservice, this._stitch, this._modalService)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'password_reset',
    );
  }

    // get and register modal to modal Manager
  void getElement(Element el) async
  {
    print('create modal');
    modal = Modal(el, onClose: Page.goToHome);

    _modalService.register('pasword_reset', modal);

    //show modal
    await Future.delayed(Duration(seconds: 1));
    _modalService.show('pasword_reset');
  }

  @override
  void onActivate(_, RouterState current) async 
  {
    token = current.parameters['token'];
    tokenID = current.parameters['tokenId'];

    print('parameters ${current.parameters}');
  }

  void send()
  {
    _stitch.resetPassword(token, tokenID, newPass)
    .then((result) async
    {
      modal.addMessage(result['message']);
      if(result['done'])modal.doWaiting(false);
      else modal.showMessage();

      await Future.delayed(Duration(seconds: 1));
      Page.goToHome();
    })
    .catchError((result) {
      modal.addMessage(result['message'], color: 'red');
    }); 
  }
}
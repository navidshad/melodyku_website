import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:html';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/directives/directives.dart';

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
  //StitchService _stitch;

  ModalService _modalService;
  Modal modal;

  String newPass;
  String token;
  String tokenID;

  // constructor ==================================
  PasswordResetPage(this.lang, this._messageService, this._userservice, /*this._stitch,*/ this._modalService)
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
    modal.doWaiting(true);

    // _stitch.resetPassword(token, tokenID, newPass)
    // .then((result) async
    // {
    //   modal.addMessage(lang.getStr('done'));
    //   modal.showMessage();
    //   modal.doWaiting(false);

    //   await Future.delayed(Duration(seconds: 1));
    //   Page.goToHome();
    // })
    // .catchError((result) {
    //   modal.addMessage(lang.getStr('LinkInvalid'), color: 'red');
    //   modal.showMessage();
    //   modal.doWaiting(false);
    // }); 
  }
}
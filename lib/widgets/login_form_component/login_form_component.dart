/// {@nodoc}
library loginFormComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'login-form',
  templateUrl: 'login_form_component.html',
  styleUrls: ['login_form_component.css'],
  directives: [
    coreDirectives,
    ElementExtractorDirective,
    formDirectives,
  ]
)
class LoginFormComponent
{
  LanguageService lang;
  UserService _userService;
  ModalService _modalService;
  Modal modal;

  bool isVisible = false;
  String activeForm = 'login';
  
  String email = '';
  String password = '';
  String apikey = '';

  String errorMessage;

  // constructor --------------------------------
  LoginFormComponent(this.lang, this._userService, this._modalService);

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    modal = Modal(el, onClose: switchForm, arg: 'login');
    _modalService.register('login', modal);
  }

  // visibility of form -------------------------
  void switchForm([String name])
  {
    if(name != null) activeForm = name;
    else if(activeForm == 'login') activeForm = 'register';
    else activeForm = 'login';

    errorMessage = null;
  }

  // login logout -------------------------------
  void login() async 
  {
    
    modal.doWaiting(true);
    
    await _userService.login(identity: email, identityType: 'phone', password: password)
      .then((r) { modal.close(); })
      .catchError((e) => errorMessage = 'wrong phone or password');

    modal.doWaiting(false);
  }

  void loginWithAPIKey() async
  {
    modal.doWaiting(true);
    dynamic result;// = await _userService.loginWithAPIKey(apikey);

    if(result['done']) modal.close();
    else {
      errorMessage = result['message'];
      modal.doWaiting(false);
    }
  }

  void register() async
  {
    modal.doWaiting(true);
    dynamic result;// = await _userService.register(email, password);

    if(result['done']) {
      modal.addMessage(lang.getStr('userCreated'), color:'yellow');
      modal.showMessage();
      switchForm('login');
    }
    else errorMessage = result['message'];
  
    modal.doWaiting(false);
  }

  void sendResetLink()
  {
    modal.doWaiting(true);

    // _mongodb.sendResetPasswordEmail(email)
    // .then((result) 
    // {
    //   modal.addMessage(lang.getStr('resetLinkSent'), color: 'yellow');
    //   modal.showMessage();
    //   modal.doWaiting(false);
    // })
    // .catchError((result)
    // {
    //   modal.addMessage(result['message'], color:'red');
    //   modal.showMessage();
    //   modal.doWaiting(false);
    // });
  }

  void sendEmailConfirmation()
  {
    modal.doWaiting(true);
    
    // _mongodb.resendConfirmationEmail(email)
    // .then((result) 
    // {
    //   modal.addMessage(lang.getStr('confirmationSent'), color: 'yellow');
    //   modal.showMessage();
    //   modal.doWaiting(false);
    // })
    // .catchError((result)
    // {
    //   modal.addMessage(result['message'], color:'red');
    //   modal.showMessage();
    //   modal.doWaiting(false);
    // });
  }
}
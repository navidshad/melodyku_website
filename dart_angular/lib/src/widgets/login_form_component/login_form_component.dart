import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/modal_service.dart';
import '../../services/language_service.dart';
import '../../services/stitch_service.dart';

import '../../directives/ElementExtractorDirective.dart';
import '../../class/modal/modal.dart';


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
  StitchService _stitch;
  Modal modal;

  bool isVisible = false;
  String activeForm = 'login';
  
  String email = '';
  String password = '';
  String apikey = '';

  String errorMessage;

  // constructor --------------------------------
  LoginFormComponent(this.lang, this._userService, this._modalService, this._stitch)
  {
    window.onKeyPress.listen((KeyboardEvent e)
    {
      //if(e.key == 'k') activeForm = (activeForm != 'apikey') ? 'apikey' : 'login';
    });
  }

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
    dynamic result = await _userService.login(email, password);

    if(result['done']) modal.close();
    else {
      errorMessage = result['message'];
      modal.doWaiting(false);
    }
  }

  void loginWithAPIKey() async
  {
    modal.doWaiting(true);
    dynamic result = await _userService.loginWithAPIKey(apikey);

    if(result['done']) modal.close();
    else {
      errorMessage = result['message'];
      modal.doWaiting(false);
    }
  }

  void register() async
  {
    modal.doWaiting(true);
    dynamic result = await _userService.register(email, password);

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

    _stitch.sendResetPasswordEmail(email)
    .then((result) 
    {
      modal.addMessage(lang.getStr('resetLinkSent'), color: 'yellow');
      modal.showMessage();
      modal.doWaiting(false);
    })
    .catchError((result)
    {
      modal.addMessage(result['message'], color:'red');
      modal.showMessage();
      modal.doWaiting(false);
    });
  }

  void sendEmailConfirmation()
  {
    modal.doWaiting(true);
    
    _stitch.resendConfirmationEmail(email)
    .then((result) 
    {
      modal.addMessage(lang.getStr('confirmationSent'), color: 'yellow');
      modal.showMessage();
      modal.doWaiting(false);
    })
    .catchError((result)
    {
      modal.addMessage(result['message'], color:'red');
      modal.showMessage();
      modal.doWaiting(false);
    });
  }
}
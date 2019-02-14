import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/modal_service.dart';
import '../../services/language_service.dart';
import '../../directives/ElementExtractorDirective.dart';
import '../../class/modal/modal.dart';


@Component(
  selector: 'login-form',
  templateUrl: 'login_form_component.html',
  styleUrls: ['login_form_component.scss.css'],
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
  LoginFormComponent(this.lang, this._userService, this._modalService)
  {
    window.onKeyPress.listen((KeyboardEvent e)
    {
      if(e.key == 'k') activeForm = (activeForm != 'apikey') ? 'apikey' : 'login';
    });
  }

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    modal = Modal(el);
    _modalService.register('login', modal);
  }

  // visibility of form -------------------------
  void switchForm([String name])
  {
    if(name != null) activeForm = name;
    else if(activeForm == 'login') activeForm = 'register';
    else activeForm = 'login';
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

    if(result['done']) switchForm('login');
    else errorMessage = result['message'];
  
    modal.doWaiting(false);
  }
}
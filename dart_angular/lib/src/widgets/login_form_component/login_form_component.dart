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
  
  String fullname = '';
  String email = '';
  String password = '';

  // constructor --------------------------------
  LoginFormComponent(this.lang, this._userService, this._modalService);

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    modal = Modal(el);
    _modalService.register('login', modal);
  }

  // visibility of form -------------------------
  void switchForm()
  {
    if(activeForm == 'login') activeForm = 'register';
    else activeForm = 'login';
  }

  // login logout -------------------------------
  void login() async 
  {
    modal.doWaiting(true);
    bool logedin = await _userService.login(email, password);

    if(logedin) modal.close();
    else modal.doWaiting(false);
  }

  void register() async
  {
    dynamic detail = {
      'fullname': fullname,
      'email': email,
      'password': password
    };
    
    bool registeredAndLogedin = await _userService.register(detail);

    if(registeredAndLogedin) modal.close();
    else modal.doWaiting(false);
  }
}
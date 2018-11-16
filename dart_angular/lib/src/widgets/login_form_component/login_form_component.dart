import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/message_service.dart';
import '../../directives/ElementExtractorDirective.dart';

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
  UserService _userService;
  MessageService _messageService;
  Element _formElement;

  bool isVisible = false;
  String activeForm = 'login';
  
  String fullname = '';
  String email = '';
  String password = '';

  // constructor --------------------------------

  LoginFormComponent(this._userService, this._messageService)
  {
    _messageService.addListener(resiveOpenMessage);
  }

  void getElement(Element el) => _formElement = el;

  // visibility of form -------------------------

  void close() => isVisible = false;

  void resiveOpenMessage(MessageDetail message) 
  {
    if(message.type != StreamType.login) return;
    //print('show login');
    isVisible = message.visible;
  }

  void switchForm()
  {
    if(activeForm == 'login') activeForm = 'register';
    else activeForm = 'login';
  }

  // login logout -------------------------------

  void login() async 
  {
    doWaiting(true);
    bool logedin = await _userService.login(email, password);

    if(logedin) close();
    else doWaiting(false);
  }

  void register()
  {
    dynamic detail = {
      'fullname': fullname,
      'email': email,
      'password': password
    };
    _userService.register(detail);
  }

  // form effect --------------------------------

  doWaiting(key)
  {
    Element cardContent = _formElement.querySelector('#cardContent');
    cardContent.style.transition = '0.5s';

    if(key) cardContent.style.opacity = '0';
    else cardContent.style.opacity = '1';
  }
}
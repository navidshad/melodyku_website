import 'package:angular/angular.dart';
import 'dart:html';
import '../../services/user_service.dart';
import '../../services/message_service.dart';

@Component(
  selector: 'login-form',
  templateUrl: 'login_form_component.html',
  styleUrls: ['login_form_component.scss.css'],
  directives: [coreDirectives]
)
class LoginFormComponent
{
  UserService _userService;
  MessageService _messageService;
  bool isVisible = false;
  String activeForm = 'login';
  
  String fullname;
  String email;
  String password;

  LoginFormComponent(this._userService, this._messageService)
  {
    _messageService.addListener(resiveOpenMessage);
  }

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

  void login()
  {
    _userService.login(email, password);
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
}
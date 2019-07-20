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
  
  String phone = '';
  String password = '';
  String code = '';

  String errorMessage;

  List<String> formIds = [
    'login', 
    'register-phone', 
    'submite-password',
    'register-phone-for-change-password',
    'submite-password-for-change'
    ];

  // constructor --------------------------------
  LoginFormComponent(this.lang, this._userService, this._modalService);

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    modal = Modal(el, onClose: showForm, arg: 'login');
    _modalService.register('login', modal);

    showForm('login');
  }

  // visibility of form -------------------------
  void showForm(sectionid) async
  {
    // clear text boxes
    phone = '';
    password = '';
    modal.clearMessages();

    // hide modal content
    await modal.doWaiting(true);

    // hide all sections
    formIds.forEach((id) =>
      modal.base.querySelector('#$id').classes.add('none'));

    // show specific section
    modal.base.querySelector('#$sectionid').classes.remove('none');

    // show modal content again
    modal.doWaiting(false);
  }

  void login() async 
  {
    modal.doWaiting(true);
    
    await _userService.login(identity: phone, identityType: 'phone', password: password)
      .then((r) async
      {
        modal.clearMessages();
        modal.addMessage('Success', color: 'green');
        modal.showMessage();

        await Future.delayed(Duration(milliseconds: 500));
        modal.close();
      })
      .catchError((e) {
        print('login error $e');
        errorMessage = 'wrong phone or password';
        showError(errorMessage);
      });

    modal.doWaiting(false);
  }

  void registerPhone() async
  {
    modal.doWaiting(true);

    if(!validatePhone())
    {
      showError('Wrong phone number');
      return;
    }

    await _userService.auth.registerSubmitId(identity: phone, identityType:'phone')
      .then((r) async
      {
        modal.clearMessages();
        modal.addMessage('Your phone number has been submitted', color: 'yellow');
        modal.showMessage();

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-password');
      })
      .catchError((e) {
        print('registerPhone error $e');
        errorMessage = 'wrong phone';
        showError(errorMessage);
      });

    modal.doWaiting(false);
  }

  void submitePassword() async
  {
    if(phone == '' || password == '' || code == '') return;

    modal.doWaiting(true);

    // submite password
    await _userService.auth
      .registerSubmitPass(identity: phone, password: password, serial: code)
      .then((r) async
      {
        modal.clearMessages();
        modal.addMessage('Success', color: 'green');
        modal.showMessage();

        await Future.delayed(Duration(milliseconds: 2000));
        showForm('login');
      })
      .catchError((e) {
        print('submitePassword error $e');
        errorMessage = 'Check your information please, and submite again';
        showError(errorMessage);
      });

    modal.doWaiting(false);
  }

  void registerPhoneForChangePassword() async
  {
    modal.doWaiting(true);

    if(!validatePhone())
    {
      showError('Wrong phone number');
      return;
    }

    await _userService.auth.registerSubmitId(identity: phone, identityType:'phone')
      .then((r) async
      {
        modal.clearMessages();
        modal.addMessage('Your phone number has been submitted', color: 'yellow');
        modal.showMessage();

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-password-for-change');
      })
      .catchError((e) {
        print('registerPhoneForChangePassword error $e');
        errorMessage = 'wrong phone';
        showError(errorMessage);
      });

    modal.doWaiting(false);
  }

  void submitePasswordForChange() async
  {
    if(phone == '' || password == '' || code == '') return;

    modal.doWaiting(true);

    // submite password
    await _userService.auth
      .changePass(identity: phone, password: password, serial: code)
      .then((r) async
      {
        modal.clearMessages();
        modal.addMessage('Success', color: 'green');
        modal.showMessage();

        await Future.delayed(Duration(milliseconds: 2000));
        showForm('login');
      })
      .catchError((e) {
        print('submitePasswordForChange error $e');
        errorMessage = 'Check your information please, and submite again';
        showError(errorMessage);
      });

    modal.doWaiting(false);
  }

  void showError(String err)
  {
    modal.clearMessages();
    modal.addMessage(err, color:'red');
    modal.showMessage();
    modal.doWaiting(false);
  }

  bool validatePhone()
  {
    phone = phone.replaceAll('+', '');
    String pattern = r'^\d{8,15}$';
    RegExp reg = RegExp(pattern, caseSensitive: false);

    return reg.hasMatch(phone);
  }
}
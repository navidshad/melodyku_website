/// {@nodoc}
library loginForm2Component;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

//import 'countries.dart';

@Component(
  selector: 'login-form2',
  templateUrl: 'login_form2_component.html',
  styleUrls: ['login_form2_component.css'],
  directives: [
    coreDirectives,
    ElementExtractorDirective,
    DirectionDirective,
    formDirectives,
    //SelectField,
    PhoneNumberField,
  ]
)
class LoginForm2Component implements OnChanges
{
  LanguageService lang;
  UserService _userService;

  bool isVisible = false;
  String activeForm = 'login';
  
  Element base;
  SectionSwitcher swicher;
  
  int phone;
  String password = '';
  int smsCode;

  String errorMessage = '';

  @Input('form')
  String form;

  // constructor --------------------------------
  LoginForm2Component(this.lang, this._userService);

  ngOnChanges(dynamic changes)
  {
    if(form != null) showForm(form);
  }

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    base = el;

    swicher = SectionSwitcher(
    [
      el.querySelector('#login'),  
      
      el.querySelector('#register-phone'), 
      el.querySelector('#confirm-phone'),
      el.querySelector('#submite-smsCode'),
      el.querySelector('#submite-password'), 

      el.querySelector('#register-phone-for-change-password'), 
      el.querySelector('#confirm-phone-for-change-password'),
      el.querySelector('#submite-smsCode-for-change-password'),
      el.querySelector('#submite-password-for-change'),
    ]);
  }

  // visibility of form -------------------------
  void showForm(sectionid, {String error}) async
  {
    // clear text boxes
    if(error != null) errorMessage = error;
    else errorMessage = '';

    // hide modal content
    swicher.show(sectionid);
  }

  void login() async 
  {
    swicher.hideAll();
    
    await _userService.login(identity: phone.toString(), identityType: 'phone', password: password)
      .then((r) async
      {
        Navigator.gotTo('vitrin');
      })
      .catchError((e) {
        print('login error $e');
        showForm('login', error:'wrongPhoneOrPassword');
      });
  }

  void registerPhone() async
  {
    swicher.hideAll();

    await _userService.auth.registerSubmitId(identity: phone.toString(), identityType:'phone')
      .then((r) async
      {
        errorMessage = 'yourPhoneNumberHasBeenSubmitted';

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-smsCode');
      })
      .catchError((e) {
        print('registerPhone error $e');
        showForm('register-phone', error:'wrongPhoneNumber');
      });
  }

  void submiteSmsCode() async
  {
    swicher.hideAll();

    _userService.auth.validateSMSCode(id: phone.toString(),  code: smsCode)
      .then((isValid)
      {
        print(isValid);
        if(isValid) showForm('submite-password');
        else{
          errorMessage = 'wrongSMSCode';
          swicher.showLast();
        }
      })
      .catchError((e)
      {
          errorMessage = e.toString();
          swicher.showLast();
      });
  }

  submiteSmsCodeForChangePassword()
  {
    swicher.hideAll();

    _userService.auth.validateSMSCode(id: phone.toString(),  code: smsCode)
      .then((isValid)
      {
        print(isValid);
        if(isValid) showForm('submite-password-for-change');
        else{
          errorMessage = 'wrongSMSCode';
          swicher.showLast();
        }
      })
      .catchError((e)
      {
          errorMessage = e.toString();
          swicher.showLast();
      });
  }

  void submitePassword() async
  {
    if(phone == null || password == '') return;

    swicher.hideAll();

    // submite password
    await _userService.auth
      .registerSubmitPass(identity: phone.toString(), password: password, serial: smsCode)
      .then((r) async
      {
        errorMessage = 'success';

        await Future.delayed(Duration(milliseconds: 2000));
        //showForm('login');
        login();
      })
      .catchError((e) {
        print('submitePassword error $e');
        showForm('submite-password', error:'passwordIsWrong');
      });
  }

  void registerPhoneForChangePassword() async
  {
    //if(!normalizePhone()) return;

    swicher.hideAll();

    // if(!validatePhone())
    // {
    //   errorMessage = 'phoneIsWrong';
    //   return;
    // }

    await _userService.auth.registerSubmitId(identity: phone.toString(), identityType:'phone')
      .then((r) async
      {
        errorMessage = 'yourPhoneNumberHasBeenSubmitted';

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-password-for-change');
      })
      .catchError((e) {
        print('registerPhoneForChangePassword error $e');
        showForm('register-phone-for-change-password', error:'phoneIsWrong');
      });
  }

  void submitePasswordForChange() async
  {
    if(phone == null || password == '') return;

    //if(!normalizePhone()) return;

    swicher.hideAll();

    // submite password
    await _userService.auth
      .changePass(identity: phone.toString(), password: password, serial: smsCode)
      .then((r) async
      {
        errorMessage = 'success';

        await Future.delayed(Duration(milliseconds: 2000));
        showForm('login');
      })
      .catchError((e) {
        print('submitePasswordForChange error $e');
        showForm('submite-password-for-change', error:'checkYourInfoAndSubmiteAgain');
      });
  }

  
}
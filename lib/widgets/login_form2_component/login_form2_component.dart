/// {@nodoc}
library loginForm2Component;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

import 'countries.dart';

@Component(
  selector: 'login-form2',
  templateUrl: 'login_form2_component.html',
  styleUrls: ['login_form2_component.css'],
  directives: [
    coreDirectives,
    ElementExtractorDirective,
    DirectionDirective,
    formDirectives,
    SelectField,
  ]
)
class LoginForm2Component
{
  LanguageService lang;
  UserService _userService;

  bool isVisible = false;
  String activeForm = 'login';
  
  Element base;
  SectionSwitcher swicher;

  List<DbField> countries = [];
  List<String> flags = [];
  
  String countryCode = '98';
  String normalizedPhone = '';
  String phone = '';
  String password = '';
  String code = '';

  String errorMessage;

  // constructor --------------------------------
  LoginForm2Component(this.lang, this._userService)
  {
    getCountries();
  }

  // get and register modal to modal Manager
  void getElement(Element el) 
  {
    base = el;

    swicher = SectionSwitcher([
      el.querySelector('#login'),  
      el.querySelector('#register-phone'), 
      el.querySelector('#submite-password'), 
      el.querySelector('#register-phone-for-change-password'), 
      el.querySelector('#submite-password-for-change'), 
    ]);

    showForm('login');
  }

  void normalizePhone()
  {
    normalizedPhone = phone;
    normalizedPhone.replaceAll('+', '');

    if(normalizedPhone.startsWith(countryCode))
      normalizedPhone = normalizedPhone.replaceRange(0, countryCode.length, '');

    if(normalizedPhone.startsWith('0'))
      normalizedPhone = normalizedPhone.replaceRange(0, 1, '');

    normalizedPhone = countryCode + normalizedPhone;
  }

  // visibility of form -------------------------
  void showForm(sectionid) async
  {
    // clear text boxes
    password = '';

    // hide modal content
    swicher.show(sectionid);
  }

  void login() async 
  {
    swicher.hideAll();

    normalizePhone();
    
    await _userService.login(identity: normalizedPhone, identityType: 'phone', password: password)
      .then((r) async
      {
        Navigator.gotTo('');
      })
      .catchError((e) {
        print('login error $e');
        errorMessage = 'wrong phone or password';
        showForm('login');
      });
  }

  void registerPhone() async
  {
    normalizePhone();

    swicher.hideAll();

    if(!validatePhone())
    {
      errorMessage = 'Wrong phone number';
      showForm('register-phone');
      return;
    }

    await _userService.auth.registerSubmitId(identity: normalizedPhone, identityType:'phone')
      .then((r) async
      {
        errorMessage = 'Your phone number has been submitted';

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-password');
      })
      .catchError((e) {
        print('registerPhone error $e');
        errorMessage = 'wrong phone';
        showForm('register-phone');
      });
  }

  void submitePassword() async
  {
    if(phone == '' || password == '' || code == '') return;

    swicher.hideAll();

    // submite password
    await _userService.auth
      .registerSubmitPass(identity: normalizedPhone, password: password, serial: code)
      .then((r) async
      {
        errorMessage = 'Success';

        await Future.delayed(Duration(milliseconds: 2000));
        showForm('login');
      })
      .catchError((e) {
        print('submitePassword error $e');
        errorMessage = 'Check your information please, and submite again';
        showForm('submite-password');
      });
  }

  void registerPhoneForChangePassword() async
  {
    normalizePhone();

    swicher.hideAll();

    if(!validatePhone())
    {
      errorMessage = 'Wrong phone number';
      return;
    }

    await _userService.auth.registerSubmitId(identity: normalizedPhone, identityType:'phone')
      .then((r) async
      {
        errorMessage = 'Your phone number has been submitted';

        await Future.delayed(Duration(milliseconds: 500));
        showForm('submite-password-for-change');
      })
      .catchError((e) {
        print('registerPhoneForChangePassword error $e');
        errorMessage = 'wrong phone';
        showForm('register-phone-for-change-password');
      });
  }

  void submitePasswordForChange() async
  {
    if(phone == '' || password == '' || code == '') return;

    normalizePhone();

    swicher.hideAll();

    // submite password
    await _userService.auth
      .changePass(identity: normalizedPhone, password: password, serial: code)
      .then((r) async
      {
        errorMessage = 'Success';

        await Future.delayed(Duration(milliseconds: 2000));
        showForm('login');
      })
      .catchError((e) {
        print('submitePasswordForChange error $e');
        errorMessage = 'Check your information please, and submite again';
        showForm('submite-password-for-change');
      });
  }

  bool validatePhone()
  {
    String pattern = r'^\d{8,15}$';
    RegExp reg = RegExp(pattern, caseSensitive: false);

    return reg.hasMatch(phone);
  }

  List<DbField> getCountries()
  {
    countriesRawDetail.forEach((raw) 
    {
      DbField field = DbField(raw['nativeName'], strvalue: raw['callingCode']);
      countries.add(field);
      //flags.add(raw['flag']);
    });
  }
}
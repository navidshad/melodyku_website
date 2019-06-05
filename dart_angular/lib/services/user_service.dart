/// {@nodoc}
library userService;

import 'dart:async';
import 'dart:html';

import 'package:melodyku/page/page.dart';
import 'package:melodyku/user/user.dart';

import 'stitch_service.dart';

export 'package:melodyku/user/user.dart';
export 'package:melodyku/core/types.dart';

class UserService 
{
  StitchService _stitch;
  User user;
  //User get user => user;

  bool isLogedIn = false;

  UserService(this._stitch);

  void loginWithLastSession()
  {
    if(_stitch.user == null) return;

    print('loginWithLastSession');

    String pName = _stitch.user.loggedInProviderName;

    print('pName $pName');

    if(pName == 'api-key'){
        user = User(_stitch.user.id, fullAccess: true);
        isLogedIn = true;
    }
    else if(pName != 'anon-user') {
      user = User(_stitch.user.id);
      isLogedIn = true;
    }
  }

  Future<dynamic> login(String email, String password) async
  {
    dynamic result;

    await _stitch.loginWithEmailPassword(email, password)
      .then((r)
      {
        result = r;
        if(result['done']) {
          isLogedIn = true;
          user = User(_stitch.user.id, getDetail: true);
        }
      }).catchError((onError){
        result = onError;
      });

    return result;
  }

  Future<dynamic> loginWithAPIKey(String key) async
  {
    dynamic result;

    await _stitch.loginWithAPIKey(key)
      .then((r)
      {
        user = User(_stitch.user.id, fullAccess: true);
        result = r;
        if(result['done']) isLogedIn = true;
      }).catchError((onError)
      {
        result = onError;
      });

    return result;
  }

  void logout() async
  {
    await promiseToFuture(_stitch.appClient.auth.logout())
      .then((r) 
      {
        user = null;
        isLogedIn = false;

        Page.goToHome();
      });
  }

  Future<dynamic> register(String email, String password) async
  {
    dynamic result = {'done':false, 'message':''};

    await _stitch.registerWithEmailPassword(email, password)
    .then((r) {
      result = r;
    })
    .catchError((onError){
        result['message'] = onError;
    });

    return result;    
  }
}
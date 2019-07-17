/// {@nodoc}
library userService;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/user/user.dart';

export 'package:melodyku/user/user.dart';
export 'package:melodyku/core/types.dart';

class UserService 
{
  AuthService auth;
  
  String token;
  User _user;
  User get user => _user;

  bool isLogedIn = false;
  //bool get isLogedIn => _isLogedIn;

  UserService(this.auth);

  void _loginAnonymous() async
  {
    token = await auth.loginAnonymous();
    Map payload = await auth.varifyToken(token);

    _loadUserFromPayload(payload);
  }

  void _loadUserFromPayload(Map payload)
  {
    UserType type = User.getType(payload['type']);
    _user = User(payload['id'], type: type, permissionId: payload['permission']);

    _saveSession(payload);

    if(type == UserType.user)
      isLogedIn = true;
  }

  void _saveSession(Map payload)
  {
    window.localStorage['token'] = token;
  }

  void loginWithLastSession() async
  {
    bool hasStoredToken = window.localStorage.containsKey('token');
    
    if(!hasStoredToken)
    {
      _loginAnonymous();
      return;
    }

    try{

        token = window.localStorage['token'];
        Map payload = await auth.varifyToken(token);
        _loadUserFromPayload(payload);

      }catch(err)
      {
        print( '== LastSession error $err');
        _loginAnonymous();
      }
  }

  Future<void> login({String identity, String identityType, String password}) async
  {
    auth.login(identity: identity, identityType: identityType, password: password)
      .then((result) async
      {
        token = result;
        Map payload = await auth.varifyToken(token);

        _loadUserFromPayload(payload);
      });
  }

  // Future<dynamic> loginWithAPIKey(String key) async
  // {
  //   dynamic result;

  //   await _stitch.loginWithAPIKey(key)
  //     .then((r)
  //     {
  //       user = User(_stitch.user.id, fullAccess: true);
  //       result = r;
  //       if(result['done']) isLogedIn = true;
  //     }).catchError((onError)
  //     {
  //       result = onError;
  //     });

  //   return result;
  // }

  void logout() async
  {
    // await promiseToFuture(_stitch.appClient.auth.logout())
    //   .then((r) 
    //   {
    //     _user = null;
    //     isLogedIn = false;

    //     Navigator.goToRawPath('/#');
    //   });

    _loginAnonymous();
    isLogedIn = false;
  }

  // Future<dynamic> register(String email, String password) async
  // {
  //   dynamic result = {'done':false, 'message':''};

  //   await _stitch.registerWithEmailPassword(email, password)
  //   .then((r) {
  //     result = r;
  //   })
  //   .catchError((onError){
  //       result['message'] = onError;
  //   });

  //   return result;    
  // }
}
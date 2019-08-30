/// {@nodoc}
library userService;

import 'dart:async';
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/user/user.dart';

export 'package:melodyku/user/user.dart';
export 'package:melodyku/core/types.dart';

class UserService 
{
  AuthService auth;

  StreamController<bool> _loginController;
  Stream<bool> get loginEvent => _loginController.stream;
  
  String token;
  User _user;
  User get user => _user;

  bool isLogedIn = false;

  UserService(this.auth)
  {
    _loginController = StreamController();
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

  Future<dynamic> login({String identity, String identityType, String password}) async
  {
    return auth.login(identity: identity, identityType: identityType, password: password)
      .then((result) async
      {
        print('login result $result');
        token = result;
        Map payload = await auth.varifyToken(token);

        _loadUserFromPayload(payload);
      });
  }

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
    {
      print('== user has been logined from local token');
      isLogedIn = true;
      _loginController.add(isLogedIn);
    }
  }

  void _saveSession(Map payload)
  {
    window.localStorage['token'] = token;
  }

  void logout() async
  {
    _loginAnonymous();
    isLogedIn = false;
    _loginController.add(isLogedIn);
  }
}
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';
import 'dart:async';


import './urls.dart';
import '../class/page/page.dart';
import '../class/user/user.dart';

import './message_service.dart';
import './stitch_service.dart';

export '../class/user/user.dart';
export '../class/types.dart';

class UserService 
{
  MessageService _messageService;
  StitchService _stitch;
  BrowserClient _http;
  String _token;

  User user;
  //User get user => user;

  bool isLogedIn = false;

  UserService(this._messageService, this._stitch)
  {
    print('an instance of userService being created');
    _http = BrowserClient();

    loginWithLastSession();
  }

  String get token => _token;

  void loginWithLastSession()
  {
    if(_stitch.user == null) return;

    String pName = _stitch.user.loggedInProviderName;

    //print('pName $pName');

    if(pName == 'api-key'){
        user = User(_stitch.user.id, fullAccess: true);
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

  void logout()
  {
    _stitch.appClient.auth.logout();
    _stitch.loginAnonymouse();

    user = null;
    isLogedIn = false;

    Page.goToHome();
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

  // other methods ----------------------------------------
  dynamic _extractData(Response resp) {
    dynamic body = json.decode(resp.body);
    //print('body $body');
    return body;
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
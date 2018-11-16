import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import '../class/user/user.dart';
import './urls.dart';


export '../class/user/user.dart';

class UserService 
{
  Client _http;
  String _token;
  User user;
  bool isLogedIn = false;

  UserService(this._http);

  Future<bool> login(String email, String password) async
  {
    dynamic form = {'email': email, 'password': password};
    
    try {
      final response = await _http.post(link_auth_login, body: form);
      final result = _extractData(response);

      if(result['status'] == 'success') {
        isLogedIn = true;
        _token = result['token'];
      }
    } 
    catch (e) {
      print('error for login()');
      _handleError(e);
    }

    await verifyUser();
    return isLogedIn;
  }

  Future<void> verifyUser() async
  {
    dynamic form = {'token': _token};

    try {
      final response = await _http.post(link_auth_verify, body: form);
      final result = _extractData(response);

      if(result['status'] == 'success') 
      {
        isLogedIn = true;
        user = User.fromJson(result['user']);
      }
      else logout();
    } 
    catch (e) {
      print('error for login()');
      _handleError(e);
    }

  }

  void logout()
  {
    _token = null;
    user = null;
    isLogedIn = false;
  }

  void register(dynamic detail)
  {

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
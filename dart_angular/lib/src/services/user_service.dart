import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';
import 'dart:async';
import '../class/user/user.dart';
import './urls.dart';

import '../class/injector.dart';

export '../class/user/user.dart';
export '../class/types.dart';

class UserService 
{
  BrowserClient _http;
  String _token;
  User user;
  bool isLogedIn = false;

  UserService()
  {
    _http = BrowserClient();

    // register this userService into Injectory.
    Injector.register(InjectorMember(this));
  }

  String get token => _token;

  Future<bool> login(String email, String password) async
  {
    dynamic form = {'email': email, 'password': password};
    
    try {
      final response = await _http.post(link_auth_login, body: form);
      final result = _extractData(response);

      print('login result: $result');

      if(result['status'] == 'success')
        _token = result['token'];

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

  Future<bool> register(dynamic detail) async
  {
    try {
      // get & set permissions
      dynamic userPermission = await _getPermission('user');
      detail['permission'] = userPermission['_id'];

      // register
      final response = await _http.post(link_auth_register, body: detail);
      final result = _extractData(response);

      print('register result: $result');

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

  Future<dynamic> _getPermissions() async 
  {
    dynamic permissions = [];

    try {
      final response = await _http.get(link_auth_permission);
      final result = _extractData(response);

      if(result['status'] == 'success')
        permissions = result['permissions'];
    } 
    catch (e) {
      print('error for _getPermissions()');
      _handleError(e);
    }

    return permissions;
  }

  Future<dynamic> _getPermission(name) async
  {
    dynamic permissions = await _getPermissions();
    dynamic permission = {};
    
    for (var item in permissions) 
      if(item['name'] == name) permission = item;

    return permission;
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
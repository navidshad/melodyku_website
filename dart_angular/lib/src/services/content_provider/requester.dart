import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../user_service.dart';

class Requester
{
  Client _http;
  UserService _userService;

  Requester(this._http, this._userService);

  Future<dynamic> post(url, {dynamic body}) async
  {
    dynamic form = body != null ? body : {};
    dynamic result;

    try {
      String token = _getToken();
      dynamic header = {'token':token};

      Response response = await _http.post(url, body: form, headers: header);
      result = _extractData(response);

      //_printRequestStatus(response, sentBody: body);
    }
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }

    return result;
  }

  Future<dynamic> get(url, {bool directResult:false}) async
  {
    dynamic result;

    try {
      String token = _getToken();
      dynamic header = {'token':token};
      Response response = await _http.get(url, headers: header);
      
      result = directResult ? response.body : _extractData(response);

      //_printRequestStatus(response);
    }
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }

    return result;
  }

  String _getToken() {
    //print('_userService.token ${_userService.token}');
    return _userService.token ?? 'none';
  }
    

  _printRequestStatus(Response response, {sentBody})
  {
    String url = response.request.url.toString();
    String method = response.request.method;
    String status = response.statusCode.toString();
    String body = response.body;

    print('Response Log ---------------');
    print('status: $status \nmethod: $method, sentBody: $sentBody, \nUrl: $url \nbody: $body');
    print('----------------------------');
  }

  dynamic _extractData(Response resp) 
  {
    dynamic body = json.decode(resp.body);
    return body;
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
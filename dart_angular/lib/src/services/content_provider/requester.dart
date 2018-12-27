import 'dart:async';
import 'package:http/http.dart';
import '../user_service.dart';

class Requester
{
  Client _http;
  UserService _userService;

  Requester(this._http, this._userService);

  Future<Response> post(url, {body}) async
  {
    dynamic form = body != null ? body : {};
    Response response;

    try {
      String token = _userService.token;
      dynamic header = {'token':token};
      response = await _http.post(url, body: form, headers: header);
    }
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }

    //_printRequestStatus(response, sentBody: body);
    return response;
  }

  Future<Response> get(url) async
  {
    Response response;

    try {
      String token = _userService.token;
      dynamic header = {'token':token};
      response = await _http.get(url, headers: header);
    }
    catch (e) {
      print('error for playlist_getById()');
      throw _handleError(e);
    }

    //_printRequestStatus(response);
    return response;
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

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
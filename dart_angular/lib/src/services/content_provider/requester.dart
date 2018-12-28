import 'dart:async';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import '../user_service.dart';

import '../../class/injector.dart';

class Requester
{
  BrowserClient _http;
  UserService _userService;

  Requester()
  {
    _http = BrowserClient();
    _userService = Injector.get<UserService>();

    // register this userService into Injectory.
    Injector.register(InjectorMember(this));
  }

  Future<Response> post(url, {body}) async
  {
    dynamic form = body != null ? body : {};
    Response response;

    try {
      String token = _getToken();
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
      String token = _getToken();
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

  String _getToken() =>
    _userService.token ?? '';

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
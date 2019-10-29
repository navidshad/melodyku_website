import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

export 'package:melodyku/mongodb/mongodb.dart';

class SMSService 
{
  Client _http;
  UserService _userService;

  SMSService(this._http, this._userService);

  Future<Map<String, String>> _getHeaders() async
	{
		await Future.doWhile(() async
		{
			await Future.delayed(Duration(milliseconds: 500));
			if(_userService.token == null) return true;
			else return false;
		});

		Map<String, String> headers = {
		  'Content-Type': 'application/json',
		  'authorization': _userService.token
		};

		return headers;
	}

  /// send varification message
  Future<dynamic> lookup(String phone, String template, 
    {String token, String token2, String token3, String messageType}) async
  {
    String url = Vars.host + '/kavenegarSender/lookup';

    Map options = {
      'save': true
    };

    if(token != null) options['token'] = token;
    if(token2 != null) options['token2'] = token2;
    if(token3 != null) options['token3'] = token3;
    if(messageType != null) options['type'] = messageType;

		Map body = {
			'phone': phone,
			'template': template,
      'options': options,
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
  }

  /// get message delivery status
  Future<dynamic> status(int messageid) async
  {
    String url = Vars.host + '/kavenegarSender/status';

		Map body = {
			'messageid': messageid,
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
  }

  /// send SMS
  Future<dynamic> sendSMS(String phone, String message, 
    {String sender, int date, String localid, String type}) async
  {
    String url = Vars.host + '/kavenegarSender/sendSMS';

    Map options = {
      'save': true
    };

    if(sender != null) options['sender'] = sender;
    if(date != null) options['date'] = date;
    if(localid != null) options['localid'] = localid;
    if(type != null) options['type'] = type;

		Map body = {
			'phone': phone,
			'message': message,
      'options': options,
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
  }

  dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		if(r.statusCode != 200) {
			print('== analizeResult mongo service err ${r.statusCode} ${r.body}');
			throw new StateError(r.body);
		}
		return _convert(r.body);
	}
}
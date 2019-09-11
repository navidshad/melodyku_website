import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:melodyku/core/core.dart';

class AuthService 
{
	Client _http;

	AuthService(this._http);

	Map<String, String> headers = {
		  'Content-Type': 'application/json',
		};

	Future<dynamic> login({String identity, String identityType, String password})
	{
		String url = Vars.host + '/user/login';

		Map body = {
			'id': identity,
			'idType': identityType,
			'password': password
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult)
			.then((rBody) => rBody['token']);
	}

	Future<dynamic> loginAnonymous({String identity, String identityType, String password})
	{
		String url = Vars.host + '/user/loginAnonymous';

		return _http.get(url)
			.then(analizeResult)
			.then((rBody) => rBody['token']);
	}

  	Future<dynamic> varifyToken(String token)
	{
		String url = Vars.host + '/varify/token';
		Map body = { 'token': token };

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult)
			.then((rBody) => rBody['peyload']);
	}

	Future<dynamic> registerSubmitId({String identity, String identityType})
	{
		String url = Vars.host + '/user/register_submit_id';

		Map body = {
			'id': identity,
			'idType': identityType,
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

	Future<dynamic> registerSubmitPass({String identity, String password, int serial})
	{
		String url = Vars.host + '/user/register_submit_pass';

		Map body = {
			'id': identity,
			'password': password,
			'serial': serial
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

	Future<dynamic> changePass({String identity, String password, int serial})
	{
		String url = Vars.host + '/user/change_pass';

		Map body = {
			'id': identity,
			'password': password,
			'serial': serial
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

	Future<dynamic> getPermission(String permissionId)
	{
		String url = Vars.host + '/user/getPermission';

		Map body = {
			'id': permissionId,
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult)
			.then((result) => result['permission']);
	}

	Future<bool> validateSMSCode({String id, int code})
	{
		String url = Vars.host + '/user/validateSMSCode';

		Map body = {
			'id': id,
			'serial': code
		};

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult)
			.then((result) => result['isValid'] as bool);
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== SC analizeResult ${r.body}');
		dynamic body = _convert(r.body);

		if(r.statusCode != 200) throw new StateError(body);
		return body;
	}
}
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:melodyku/core/core.dart';

class AuthService 
{
	Client _http;

	AuthService(this._http);

	Future<String> login({String identity, String identityType, String password})
	{
		String url = Vars.host + '/user/login';

		Map body = {
			'id': identity,
			'idType': identityType,
			'password': password
		};

		return _http.post(url, body: body)
			.then(analizeResult)
			.then((rBody) => rBody['token']);
	}

	Future<String> loginAnonymous({String identity, String identityType, String password})
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

		return _http.post(url, body: body)
			.then(analizeResult)
			.then((rBody) => rBody['peyload']);
	}

	Future<void> registerSubmitId({String identity, String identityType})
	{
		String url = Vars.host + '/user/register_submit_id';

		Map body = {
			'id': identity,
			'idType': identityType,
		};

		return _http.post(url, body: body)
			.then(analizeResult);
	}

	Future<void> registerSubmitPass({String identity, String password, String serial})
	{
		String url = Vars.host + '/user/register_submit_pass';

		Map body = {
			'id': identity,
			'password': password,
			'serial': serial
		};

		return _http.post(url, body: body)
			.then(analizeResult);
	}

	Future<dynamic> getPermission(String permissionId)
	{
		String url = Vars.host + '/user/getPermission';

		Map body = {
			'id': permissionId,
		};

		return _http.post(url, body: body)
			.then(analizeResult)
			.then((result) => result['permission']);
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== SC analizeResult ${r.body}');
		if(r.statusCode != 200) throw new StateError(r.body);
		return _convert(r.body);
	}
}
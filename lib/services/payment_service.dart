import 'package:http/http.dart';
import 'dart:convert';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/services/services.dart';

class PaymentService
{
	Client _http;
	UserService _userService;

	PaymentService(this._http, this._userService);
	
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

	Future<List<Getway>> getWays() async
	{
		String url = Vars.host + '/payment/getways';

		Map<String, String> headers = await _getHeaders();
		
		return _http.get(url, headers: headers)
			.then(analizeResult)
			.then((result) 
			{
				List<Getway> gates = [];

				result['getways'].forEach((detail) {
					Getway gate = Getway(detail['title'], detail['currency']);
					gates.add(gate);
				});

				return gates;
			});
	}

	Future<Factor> createFactor(String tariffid, Currency currency) async
	{
		String url = Vars.host + '/payment/createFactor';

		Map<String, String> headers = await _getHeaders();

		Map body = {
			'currency': getCurrencyAsStr(currency),
			'tariffid': tariffid
		};

		return _http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult)
			.then((result) {
				Map detail = validateFields(result['factor'], SystemSchema.factor);
				Factor factor = Factor.fromMap(detail);
				return factor;
			});
	}

	Future<String> getPaylink(String factorid, String getway) async
	{
		String url = Vars.host + '/payment/getPayLink';

		Map<String, String> headers = await _getHeaders();

		Map body = {
			'getway': getway,
			'factorid': factorid
		};

		return _http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult)
			.then((result) {
				return result['link'];
			});
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== analizeResult ${r.body}');
		if(r.statusCode != 200) throw new StateError(r.body);
		return _convert(r.body);
	}
}
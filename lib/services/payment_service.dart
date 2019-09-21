import 'package:http/http.dart';
import 'dart:convert';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/services/services.dart';

class PaymentService
{
	Client _http;
	UserService _userService;
	MongoDBService _mongodb;

	List<String> currencies = [];

	PaymentService(this._http, this._userService, this._mongodb)
	{
		getCurrencies().then((r) => currencies = r);
	}

	List<DbField> getCurrenciesDbFields()
	{
		List<DbField> list = [];

		currencies.forEach((cur)
		{
			DbField base = DbField(cur, 
				dataType: DataType.object, 
				fieldType: FieldType.object, 
				subFields: [
					DbField('isActive', customTitle: 'isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
					DbField('price', dataType: DataType.int, fieldType: FieldType.number),
				]);

			list.add(base);
		});

		return list;
	}
	
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

	Future<List<Getway>> getWays(String currency) async
	{
		String url = Vars.host + '/payment/getways';

		Map<String, String> headers = await _getHeaders();
		
		return _http.get(url, headers: headers)
			.then(analizeResult)
			.then((result) 
			{
				List<Getway> gates = [];

				print(result['getways']);

				result['getways'].forEach((detail) 
				{
					detail['currencies'].forEach((cur)
					{
						Getway gate = Getway(detail['title'], cur);
					
						if(gate.currency == currency)
							gates.add(gate);
					});
				});

				return gates;
			});
	}

	Future<List<String>> getCurrencies() async
	{
		String url = Vars.host + '/payment/getCurrencies';

		Map<String, String> headers = await _getHeaders();
		
		return _http.get(url, headers: headers)
			.then(analizeResult)
			.then((r) 
			{
				List<String> list = [];

				r['list'].forEach((vl) => list.add(vl as String));

				return list;
			});
	}

	Future<Factor> createFactor({String type, String id, String currency, String coupen}) async
	{
		String url = Vars.host + '/payment/createFactor';

		Map<String, String> headers = await _getHeaders();

		Map body = {
			'currency': currency,
			'type': type,
			'id': id,
		};

		if(coupen != null && coupen.length > 0)
			body['coupen'] = coupen;

		return _http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult)
			.then((result) {
				Map detail = validateFields(result['factor'], SystemSchema.factor);
				Factor factor = Factor.fromMap(detail);
				return factor;
			});
	}

	Future<Factor> getFactor(String id) async
	{
		Map query = {
			'_id'	: id,
			'refId'	: _userService.user.id,
		};

		return _mongodb.findOne(database: 'user', collection: 'factor', query: query)
			.then((result) 
			{
				if(result == null) return null;

				Map detail = validateFields(result, SystemSchema.factor);
				Factor factor = Factor.fromMap(detail);
				return factor;
			}).catchError(print);
	}

	Future<String> getPaylink(int factorid, String getway) async
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
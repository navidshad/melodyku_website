import 'package:http/http.dart';
import 'dart:convert';

import 'package:melodyku/core/core.dart';

class StitchCatcherService 
{
	Client http;

	Map<String, String> headers = {
			'Content-Type': 'application/json'
		};

	StitchCatcherService()
	{
		http = Client();
	}

	Future<dynamic> getAll({String collection})
	{
		Map body = {
			'collection': collection,
		};

		String url = Vars.stitchCatcherUrl + '/getAll';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> getById({String collection, String id})
	{
		Map body = {
			'collection': collection,
			'id': id,
		};

		String url = Vars.stitchCatcherUrl + '/getById';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<void> updateCatch({String collection})
	{
		Map body = {
			'collection': collection,
		};

		String url = Vars.stitchCatcherUrl + '/updateCatch';

		return http.post(url, headers: headers, body: json.encode(body));
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== SC analizeResult ${r.body}');
		if(r.statusCode != 200) throw new StateError(r.body);
		return _convert(r.body);
	}
}
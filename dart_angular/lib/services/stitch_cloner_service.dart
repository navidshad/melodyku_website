import 'package:http/http.dart';
import 'dart:convert';

import 'package:melodyku/core/core.dart';

class StitchClonerService 
{
	Client http;

	Map<String, String> headers = {
			'Content-Type': 'application/json'
		};

	StitchClonerService()
	{
		http = Client();
	}

	Future<dynamic> find({String collection, Map query, Map options})
	{
		Map body = {
			'collection': collection,
			'query': query,
			'options': options ?? {}
		};

		String url = Vars.stitchClonerUrl + '/find';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> findOne({String collection, Map query, Map options})
	{
		Map body = {
			'collection': collection,
			'query': query,
			'options': options ?? {}
		};

		String url = Vars.stitchClonerUrl + '/findOne';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> count({String collection, Map query})
	{
		Map body = {
			'collection': collection,
			'query': query,
		};

		String url = Vars.stitchClonerUrl + '/count';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> updateOne({String collection, Map query, Map update})
	{
		Map body = {
			'collection': collection,
			'query': query,
			'update': update
		};

		String url = Vars.stitchClonerUrl + '/updateOne';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> insertOne({String collection, Map doc})
	{
		Map body = {
			'collection': collection,
			'doc': doc,
		};

		String url = Vars.stitchClonerUrl + '/insertOne';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> removeOne({String collection, Map query})
	{
		Map body = {
			'collection': collection,
			'query': query,
		};

		String url = Vars.stitchClonerUrl + '/removeOne';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> aggregate({String collection, List<Map> piplines})
	{
		Map body = {
			'collection': collection,
			'piplines': piplines,
		};

		String url = Vars.stitchClonerUrl + '/aggregate';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	Future<dynamic> getByIds({String collection, List<String> ids, Map sort})
	{
		Map body = {
			'collection': collection,
			'ids': ids,
		};

		if(sort != null) body['sort'] = sort;

		String url = Vars.stitchClonerUrl + '/getByIds';

		return http.post(url, headers: headers, body: json.encode(body))
			.then(analizeResult);
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== SC analizeResult ${r.body}');
		if(r.statusCode != 200) throw new StateError(r.body);
		return _convert(r.body);
	}
}
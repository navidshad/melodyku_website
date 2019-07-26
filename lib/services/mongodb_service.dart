import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

export 'package:melodyku/mongodb/mongodb.dart';

class MongoDBService 
{
	Client _http;
  	UserService _userService;

	MongoDBService(this._http, this._userService);

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

	Future<dynamic> find({String database, String collection, Map query=const{}, Map options=const{}}) async
	{
		String url = Vars.host + '/contentProvider/find';

		Map body = {
			'database': database,
			'collection': collection,
			'query': query,
      		'options': options
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

	Future<dynamic> findOne({String database, String collection, Map query}) async
	{
		String url = Vars.host + '/contentProvider/findOne';

		dynamic body = {
			'database': database,
			'collection': collection,
			'query': query,
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> count({String database, String collection, Map query=const{}}) async
	{
		String url = Vars.host + '/contentProvider/count';

		dynamic body = {
			'database': database,
			'collection': collection,
			'query': query,
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> updateOne({String database, String collection, Map query, Map update, Map options=const{}}) async
	{
		String url = Vars.host + '/contentProvider/updateOne';

		dynamic body = {
			'database': database,
			'collection': collection,
			'query': query,
			'update': update,
			'options': options
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> insertOne({String database, String collection, Map doc}) async
	{
		String url = Vars.host + '/contentProvider/insertOne';

		dynamic body = {
			'database': database,
			'collection': collection,
			'doc': doc,
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> removeOne({String database, String collection, Map query}) async
	{
		String url = Vars.host + '/contentProvider/removeOne';

		dynamic body = {
			'database': database,
			'collection': collection,
			'query': query,
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> aggregate({String database, String collection, List<Map> piplines, Map accessQuery=const{}}) async
	{
		String url = Vars.host + '/contentProvider/aggregate';

		dynamic body = {
			'database': database,
			'collection': collection,
			'piplines': piplines,
			'accessQuery': accessQuery
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> findByIds({String database, String collection, List<String> ids}) async
	{
		String url = Vars.host + '/contentProvider/getByIds';

		dynamic body = {
      		'database': database,
			'collection': collection,
			'IDs': ids,
		};

		Map<String, String> headers = await _getHeaders();

		return _http.post(url, body: json.encode(body), headers: headers)
			.then(analizeResult);
	}

  	Future<dynamic> findById({String database, String collection, String id}) async
	{
		dynamic body = {
			'database': database,
			'collection': collection,
			'query': { '_id': id },
		};

    	return findOne(database: database, collection: collection, query: body);
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		//print('== analizeResult ${r.body}');
		if(r.statusCode != 200) throw new StateError(r.body);
		return _convert(r.body);
	}
}
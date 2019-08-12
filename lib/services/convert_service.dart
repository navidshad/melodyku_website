import 'package:http/http.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class ConvertService 
{
	Client _http;
	UserService _userService;
	IO.Socket socket;

	List<String> logs = [];
	bool isConverting = false;

	ConvertService()
	{
		_http = Client();
		_userService = Injector.get<UserService>();
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

	void connectToSocket()
	{
		String orgine = Vars.host;
		socket = IO.io(orgine);

		socket.on('connect', (_) {
		  print('connected to socket');
		  socket.emit('getConverterStatus');
		});

		socket.on('getConverterStatus', (result) => isConverting = result['isConverting']);
		socket.on('onConvertReport', (msg) => logs.add(msg));
	}

	Future<void> convertById(String preset, String id) async
	{
		String url = Vars.host + '/converter/convert';

		Map body = { 
			'preset': preset, 
			'id': id,
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
      .then(analizeResult);
	}

  Future<void> removeById(String version, String id) async
	{
		String url = Vars.host + '/converter/remove';

		Map body = { 
			'version': version, 
			'id': id,
		};

		Map<String, String> headers = await _getHeaders();
		
		return _http.post(url, body: json.encode(body), headers: headers)
      .then(analizeResult);
	}

	void convertAll(String preset) async
	{
		if(isConverting) return;

		String url = Vars.host + '/converter/convertAll';

		Map body = { 'preset': preset, };
		Map<String, String> headers = await _getHeaders();
		
		_http.post(url, body: json.encode(body), headers: headers)
			.then((r) {
				isConverting = true;
			});
	}

	void stop() async
	{
		if(!isConverting) return;

		String url = Vars.host + '/converter/stopConvert';

		Map<String, String> headers = await _getHeaders();
		
		_http.post(url, headers: headers)
			.then((r) {
				isConverting = false;
			});
	}

	void clearLog() => logs = [];

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
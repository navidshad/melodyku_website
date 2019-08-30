import 'package:http/http.dart';
import 'dart:convert';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/js_interop/js_interop.dart';

class AppshellService
{
	Client _http;

	String version = '';
	String serverVersion;

	AppshellService()
	{
		_loadSession();
		_http = Client();
		getVersion();
	}

	void update() async
	{
		version = serverVersion;
		_saveSession();

		reloadPage(true);
	}

	void getVersion()
	{
		String path = window.location.origin + '/version.json';
		_http.get(path)
			.then(analizeResult)
			.then((result) 
			{
				version = result['web-client'];
				_saveSession();
			});
	}

	void _loadSession()
	{
		version = window.localStorage['version'];
	}

	void _saveSession()
	{
		window.localStorage['version'] = version;
	}

	dynamic _convert(String jsonString) => jsonDecode(jsonString);

	dynamic analizeResult(Response r)
	{
		if(r.statusCode != 200) {
			throw new StateError(r.body);
		}
		return _convert(r.body);
	}
}
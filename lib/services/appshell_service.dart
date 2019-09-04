import 'package:http/http.dart';
import 'dart:convert';
import 'dart:html';

import 'package:melodyku/core/core.dart' as core;
import 'package:melodyku/services/services.dart';
import 'package:melodyku/purechat/purechat_js.dart';

class AppshellService
{
	Client _http;
	UserService _userService;
  PureChatAPI purechatAPI;

	String version = '';
	String serverVersion;

	AppshellService(this._userService)
	{
		_http = Client();
		getVersion();

		_userService.loginEvent.listen(onLoginEvent);
    getPureChatApi().then((api) => purechatAPI = api);
	}

	void onLoginEvent(bool isLoggedIn)
	{
		if(!isLoggedIn) core.Navigator.gotTo('vitrin');
	}

	void getVersion()
	{
		String path = window.location.origin + '/version.json';
		_http.get(path)
			.then(analizeResult)
			.then((result) => version = result['web-client']);
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
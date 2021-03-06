import 'package:http/http.dart';
import 'dart:convert';
import 'dart:html';

import 'package:melodyku/core/core.dart' as core;
import 'package:melodyku/services/services.dart';
import 'package:melodyku/purechat/purechat_js.dart';

import 'package:melodyku/js_interop/app_installer.dart' as installer;

class AppshellService
{
	Client _http;
	UserService _userService;
	AnalyticService _analytic;
	LanguageService lang;
  PureChatAPI purechatAPI;

	String version = '';
	String serverVersion;

	AppshellService(this._userService, this.lang)
	{
		_http = Client();
		getVersion();

		_userService.loginEvent.listen(onLoginEvent);
    getPureChatApi().then((api) => purechatAPI = api);

    registerListeners();
	}

	void onLoginEvent(bool isLoggedIn)
	{
		if(!isLoggedIn) core.Navigator.gotTo('vitrin');
	}

	bool getInstallSupportStatus() => installer.getInstallSupportStatus();
	
	void installPWA() {
		installer.installPWA()
		.then((value) => _analytic.trackEvent('installing', 
			category: 'PWA', value: value.toString()));
	}

	void getVersion()
	{
		String path = window.location.origin + '/version.json';
		_http.get(path)
			.then(analizeResult)
			.then((result) => version = result['web-client']);
	}

	void checkUpdate() async
	{
		bool allowReload = window.confirm(lang.getStr('melodykuHasBeenUpdated'));
		if(allowReload) window.location.reload();
		
		//window.alert(lang.getStr('melodykuHasBeenUpdated', {'VN': version}));
	}

	void registerListeners()
	{
		if(window.navigator.serviceWorker == null) return;
		
		window.navigator.serviceWorker.onMessage.listen((mess)
		{
			print('resive a mesage from sw ${mess.data}');

			String action = mess.data['action'];

			if(action == 'PROMPT_UPDATE_MESSAGE')
				checkUpdate();
		});

		// window.onError.listen((Event e){
		// 	e.target.
		// });
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
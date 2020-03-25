//import 'package:gtag_analytics/gtag_analytics.dart';
import 'g_interop.dart';
import 'package:js/js_util.dart' as js;
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/payment/payment.dart';

class AnalyticService {

	String trackID =  'G-W3GJKPRMNW';// 'UA-133720746-2';
	UserService _userService;

	AnalyticService(this._userService)
	{
		_userService.loginEvent.listen(onLoginEvent);
	}

	void trackPage(String name) 
	{
		String href = window.location.href;
		String path = (href.split('#').length > 1) ? href.split('#')[1]: '/';

		send('config', trackID, js.jsify(
			{
				'page_title' : name,
  				'page_path': path
			})
		);
	}

	void trackFactor(Factor factor)
	{
		
	}

	void trackException(String description, {fatal=false,}) 
	{
		send('event', 'exception', js.jsify(
			{
				'description' : description,
  				'fatal': fatal
			})
		);
	}

	void trackEvent(String action, {String category='', String label='', String value=''}) 
	{
		send('event', action, js.jsify(
			{
				'event_category' : category,
  				'event_label': label,
  				'value': value
			})
		);
	}

	void onLoginEvent(bool isLogedIn)
	{
		Map config = {'user_id': ''};

		if(isLogedIn) config['user_id'] = _userService.user.id;

		setOptions('set', js.jsify(config));
	}
}
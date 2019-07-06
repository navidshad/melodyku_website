//import 'package:gtag_analytics/gtag_analytics.dart';
import 'g_interop.dart';
import 'package:js/js_util.dart' as js;
import 'dart:html';

class AnalyticService {

	String trackID = 'UA-133720746-2';

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

	void trackException(String description, {fatal=false,}) 
	{
		send('event', 'exception', js.jsify(
			{
				'description' : description,
  				'fatal': fatal
			})
		);
	}

	void trackEvent(String action, {String category, String label, String value}) 
	{
		send('event', action, js.jsify(
			{
				'event_category' : category,
  				'event_label': label,
  				'value': value
			})
		);
	}
}
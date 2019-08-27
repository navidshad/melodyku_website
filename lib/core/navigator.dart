/// {@nodoc}
library navigator;

import 'dart:html';
import 'injector.dart';
import 'routes.dart';

class Navigator 
{
	static gotTo(String page, {Map<String, String> parameters=const{}})
	{
		String pathName = Injector.get<PageRoutes>().getRouterUrl(page, parameters);
		Uri url = Uri.http(window.location.host, pathName);
		String newPath = '#${url.path}';
		window.location.replace(newPath);
	}

	static goToRawPath(String path)
	{
		window.location.replace(path);
	}
}
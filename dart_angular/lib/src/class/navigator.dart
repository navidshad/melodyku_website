import 'dart:html';

class Navigator 
{
	static gotTo(String page, {Map<String, String> parameters=const{}})
	{
		Uri url = Uri.http(window.location.host, page, parameters);
		String newPath = '#${url.path}';
		window.location.replace(newPath);
	}

	static goToRawPath(String path)
	{
		window.location.replace(path);
	}
}
@JS()
library main;

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js;

@JS('Object')
class Objectjs {
	external static List<String> keys(dynamic object);
	external static List<dynamic> valus(dynamic object);
}

dynamic convertFromJS(dynamic jsObject)
{
	dynamic newObject = {};

	Objectjs.keys(jsObject).forEach((key) {
		newObject[key] = js.getProperty(jsObject, key);
	});

	return newObject;
}

dynamic deleteDynamicMembers(dynamic object, List<String> members)
{
	dynamic jsObject = js.jsify(object);
	dynamic newObject = {};

	Objectjs.keys(jsObject).forEach((key) 
	{
		bool isValid = true;

		members.forEach((member) {
			if(key == member) isValid = false;
		});

		if(isValid) newObject[key] = js.getProperty(jsObject, key);
	});

	return newObject;
}

Map<String, String> dynamicToMapString(dynamic object)
{
	dynamic jsObject = js.jsify(object);
	Map<String, String> newMap = {};

	Objectjs.keys(jsObject).forEach((key) {
		newMap[key] = js.getProperty(jsObject, key);
	});

	return newMap;
}

List<String> getKeies(dynamic jsObject, {List<String> removes = const []})
{
	List<String> keies = [];

	Objectjs.keys(jsObject).forEach((key) 
	{
		bool isValid = true;

		removes.forEach((member) {
			if(key == member) isValid = false;
		});

		if(isValid) keies.add(key);
	});

	return keies;
}

dynamic getNavigatorDetail({int total=10, int page=1, int perPage=5})
{
	int _total_pages = (total/perPage).toInt();
	if(page > _total_pages) page = 1;

	int from = 0;
	if(perPage == 1) from = page-1;
	else from = (perPage * page) - perPage;

	if (page <= 1) from = 0;

	Map result = {'from':from, 'to':perPage};
	return result;
}
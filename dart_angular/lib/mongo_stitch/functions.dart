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

		print(key);

		removes.forEach((member) {
			if(key == member) isValid = false;
		});

		if(isValid) keies.add(key);
	});

	return keies;
}
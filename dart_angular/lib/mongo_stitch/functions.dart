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

Map<String, String> dynamicToMapString(dynamic object)
{
	dynamic jsObject = js.jsify(object);
	Map<String, String> newMap = {};

	Objectjs.keys(jsObject).forEach((key) {
		newMap[key] = js.getProperty(jsObject, key);
	});

	return newMap;
}
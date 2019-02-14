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
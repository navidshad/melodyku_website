@JS()
library main;

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js;

import 'field.dart';

// import 'date_time.dart';
// export 'date_time.dart';

@JS('Object')
class Objectjs {
	external static List<String> keys(dynamic object);
	external static List<dynamic> valus(dynamic object);
}

@JS('Date')
class JSDate{

	external factory JSDate(int year, int monthIndex, [int day, int hours, int minutes, int seconds]);

	external int getFullYear();
	external int getMonth();
	external int getDate();
	external int getHours();
	external int getMinutes();
	external int getSeconds();
}


enum jsTypes {String, Bool, Int, Double, Object, Array}
dynamic convertFromJS(dynamic jsObject, {List<String> stringArrays = const[], List<String>stringObjects = const[]})
{
	dynamic newObject = {};

	Objectjs.keys(jsObject).forEach((key) 
	{
		dynamic value = js.getProperty(jsObject, key);

		bool isObject = false;
		stringObjects.forEach((field) {
			if(field == key) isObject = true;
		});

		if(isObject) 
		 	newObject[key] = convertFromJS(value, stringArrays: stringArrays, stringObjects: stringObjects);

		// else newObject[key] = value;
		else newObject[key] = value;
	});

	return newObject;
}

Map convertToMap(dynamic jsObject, List<DbField> customFields)
{

	Map newObject = {};
	List<DbField> fields = customFields ?? [];

	//_id field
	try{
		dynamic id = js.getProperty(jsObject, '_id');
		if(id != null) newObject['_id'] = id;
	}catch(e){
		print('_id catch | $e');
	}
	
	// other fields
	fields.forEach((DbField field) 
		{
			dynamic value;

			try {
				value = js.getProperty(jsObject, field.key);
			}catch(e){
				//print('convertToMap forEach ${field.key} is null');
			}

			//print('convertToMap forEach ${field.key} ${field.dataType} = $value');

			// string field
			if(field.dataType == DataType.string)
			{
				if(value == null) value = '';
				newObject[field.key] = value.toString();
			}
			
			// bool field
			else if(field.dataType == DataType.bool) 
			{
				try{
					newObject[field.key] = bool.fromEnvironment(value.toString());
				}catch(e){
					print('bool array catch | key ${field.key}, value ${value}');
					newObject[field.key] = false;
				}
			}

			else if(field.dataType == DataType.int || field.dataType == DataType.float)
			{
				if(value == null) value = 0;
				
				newObject[field.key] = value;
			}

			// string array
			else if(field.dataType == DataType.array_string)
			{
				List<String> stringArray = [];

				try{
					value.forEach((element) 
						=> stringArray.add(element.toString()));
				}catch(e){
					print('string array catch | key ${field.key}, value ${value}');
				}

				newObject[field.key] = stringArray;
			}

			// object array
			else if(field.dataType == DataType.array_object)
			{
				List<Map> objectArray = [];

				try{
					value.forEach((element) {
						Map newMember = convertToMap(element, field.subFields);
						objectArray.add(newMember);
					});
				}catch(e){
					print('object array catch | key ${field.key}, value ${value}');
				}

				newObject[field.key] = objectArray;
			}

			// object field
			else if(field.dataType == DataType.object)
			{
				try{
					newObject[field.key] = convertToMap(value, field.subFields);
				}catch(e){
					print('object field catch | key ${field.key}, value ${value}');
					newObject[field.key] = convertToMap({}, field.subFields);
				}
			}

			// DateTime
			else if(field.dataType == DataType.dateTime)
			{
				try{
					JSDate jsDate = value; //JSDate(value.toString());
					newObject[field.key] = jsDateToDateTime(jsDate);
				}catch(e){
					print('dateTime field catch | key ${field.key}, value ${value} $e');
					newObject[field.key] = null;
				}
			}

		});

	//print('convertToMap $newObject');
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

		if(isValid) newObject[key] = object[key];
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
	int _total_pages = total~/perPage;
	if(page > _total_pages) page = 1;

	int from = 0;
	if(perPage == 1) from = page-1;
	else from = (perPage * page) - perPage;

	if (page <= 1) from = 0;

	Map result = {'from':from, 'to':perPage};
	return result;
}

dynamic normalize(dynamic object)
{
	dynamic normalized = {};

	getKeies(js.jsify(object)).forEach((key) 
	{
		//print('key $key');

		// _id
		if(key == '_id') normalized[key] = object[key];

		// normalizing field and specify the type of it
		// bool
		else if(object[key] == 'true' && object[key] == 'false')
			normalized[key] = bool.fromEnvironment(object[key]);
		// int
		else if (int.tryParse(object[key].toString()) != null)
			normalized[key] = int.tryParse(object[key].toString());
		// double
		else if (double.tryParse(object[key].toString()) != null)
			normalized[key] = double.tryParse(object[key].toString());

		// json form
		else normalized[key] = object[key];
		// else {
		// 	try{
		// 		String jsonString = json.encode(object[key]);
		// 		normalized[key] = json.decode(jsonString);
		// 	}
		// 	catch(e){
		// 		normalized[key] = object[key];
		// 	}
		// }
	});

	return normalized;
}

Map DateTimeToMap(DateTime date)
{
	Map detail = {
		'year'		: date.year,
		'monthIndex': date.month,
		'day'		: date.day,
		'hours'		: date.hour,
		'minutes'	: date.minute,
		'seconds'	: date.second,
		'milliseconds': date.millisecond,
	};

	return detail;
}

DateTime jsDateToDateTime(JSDate jsDate)
{
	DateTime dateTime = DateTime(jsDate.getFullYear(), jsDate.getMonth(), jsDate.getDate(), jsDate.getHours(), jsDate.getMinutes());
	return dateTime;
}

JSDate dateTimeToJSDate(DateTime date)
{
	date = date.toUtc();
	JSDate jsDate = JSDate(date.year, date.month, date.day, date.hour, date.minute, date.second);
	//print('jsDate ${jsDate.toString()}');
	return jsDate;
}
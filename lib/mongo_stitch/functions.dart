/// {@nodoc}
library mongo_utilities;

import 'package:js/js_util.dart' as js;
import 'js_interop.dart';

import 'field.dart';
import 'package:melodyku/core/injector.dart';
import 'package:melodyku/services/services.dart';


/// convert a js object into dart Map by providing an schema.
/// 
/// {@category mongo_stitch}
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

			// inject language fields
			if(field.key == 'local_title')
				field.subFields = Injector.get<LanguageService>().getLanguageFiels();

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
				if(value.runtimeType == bool) newObject[field.key] = value;
				else {
					try{
						newObject[field.key] = bool.fromEnvironment(value.toString());
					}catch(e){
						//print('bool catch | key ${field.key}, value ${value}');
						newObject[field.key] = false;
					}
				}
			}

			else if(field.dataType == DataType.int || field.dataType == DataType.float)
			{
				if(value == null) value = 0;
				num n = value;

				if(field.dataType == DataType.int)
					newObject[field.key] = n.toInt();
					
				else if(field.dataType == DataType.float)
					newObject[field.key] = n.toDouble();
			}

			// string array
			else if(field.dataType == DataType.array_string)
			{
				List<String> stringArray = [];

				try{
					value.forEach((element) 
						=> stringArray.add(element.toString()));
				}catch(e){
					//print('string array catch | key ${field.key}, value ${value}');
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
					//print('object array catch | key ${field.key}, value ${value}');
				}

				newObject[field.key] = objectArray;
			}

			// object field
			else if(field.dataType == DataType.object)
			{
				try{
					newObject[field.key] = convertToMap(value, field.subFields);
				}catch(e){
					//print('object field catch | key ${field.key}, value ${value}');
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
					//print('dateTime field catch | key ${field.key}, value ${value} $e');
					newObject[field.key] = null;
				}
			}

		});

	//print('convertToMap $newObject');
	return newObject;
}

/// create a navigator detail for page navigation.
/// 
/// {@category mongo_stitch}
Map getNavigatorDetail({int total=10, int page=1, int perPage=5})
{
	int _total_pages = (total/perPage).ceil();
	if(page > _total_pages) page = _total_pages;

	int from = 0;
	if(perPage == 1) from = page-1;
	else from = (perPage * page) - perPage;

	if (page <= 1) from = 0;

	Map result = {'pages': _total_pages, 'from':from, 'to':perPage};
	return result;
}

/// convert a js Date into DateTime
/// 
/// {@category mongo_stitch}
DateTime jsDateToDateTime(JSDate jsDate)
{
	DateTime dateTime = DateTime(jsDate.getFullYear(), jsDate.getMonth(), jsDate.getDate(), jsDate.getHours(), jsDate.getMinutes());
	return dateTime;
}

/// convert a DateTime object into js Date.
/// 
/// {@category mongo_stitch}
JSDate dateTimeToJSDate(DateTime date)
{
	date = date.toUtc();
	JSDate jsDate = JSDate(date.year, date.month, date.day, date.hour, date.minute, date.second);
	//print('jsDate ${jsDate.toString()}');
	return jsDate;
}
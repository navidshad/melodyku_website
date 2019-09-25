import 'package:melodyku/core/injector.dart';
import 'package:melodyku/services/services.dart';

Map validateFields(dynamic object, List<DbField> customFields)
{

	Map newObject = {};
	List<DbField> fields = customFields ?? [];

	//_id field
	try{
		dynamic id = object['_id'];
		if(id != null) newObject['_id'] = id;
	}catch(e){
		//print('_id catch | $e');
	}
	
	// other fields
	fields.forEach((DbField field) 
		{
			dynamic value;

			try {
				value = object[field.key];
			}catch(e){
				//print('convertToMap forEach ${field.key} is null');
			}

			// inject language fields
			if(field.key.startsWith('local_')){
				//print('== language fields injected ${field.key}');
				field.subFields = Injector.get<LanguageService>().getLanguageFiels();
			}

			//print('convertToMap forEach ${field.key} ${field.dataType} = $value');

			// string field
			if(field.dataType == DataType.string)
			{
				if(value == null) value = '';

				if(!field.isLowerCase) newObject[field.key] = value.toString();
				else newObject[field.key] = value.toString().toLowerCase();
			}
			
			// bool field
			else if(field.dataType == DataType.bool) 
			{
				if(value.runtimeType.toString() == 'bool') newObject[field.key] = value;
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
				num n = num.parse(value.toString());

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
						Map newMember = validateFields(element, field.subFields);
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
					newObject[field.key] = validateFields(value, field.subFields);
				}catch(e){
					//print('object field catch | key ${field.key}, value ${value}');
					newObject[field.key] = validateFields({}, field.subFields);
				}
			}

			// DateTime
			else if(field.dataType == DataType.dateTime)
			{
				try{
					DateTime date = DateTime.parse(value);
					newObject[field.key] = date;
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
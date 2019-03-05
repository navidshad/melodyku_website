import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:convert';

import '../../../../class/utility/collection_options.dart';

@Component(
	selector:'one-layered-object',
	templateUrl: 'one_layered_object.html',
	styleUrls: ['one_layered_object.scss.css'],
	directives: [
		coreDirectives
	]
)
class OneLayeredObject 
{
	List<SubField> fields = [];

	void addValueToObjectFiled(SubField field, String value) =>
		object[field.key] = value;

	String getValueOfObjectField(key)
	{
		String value = '';

		try{
			value = object[key];
		}
		catch(e){}

		return value;
	}

	@Input()
	dynamic object;

	@Input()
	set customFields(Map<String, SubField> cf) 
	{
		cf.forEach((String key, value) => fields.add(value));
	}

	bool chackNullObject()
	{
		if(object == null) object = {};
		return true;
	}
}
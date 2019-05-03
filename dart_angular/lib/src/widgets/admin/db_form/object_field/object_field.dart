import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:html';
import 'dart:convert';

import '../../../../class/utility/collection_options.dart';

import '../../db_form/select_field/select_field.dart';

@Component(
	selector:'object-field',
	templateUrl: 'object_field.html',
	styleUrls: ['object_field.css'],
	directives: [
		coreDirectives,
		formDirectives,
		ObjectField,
		SelectField,
	],
	exports: [
		FieldType,
	]
)
class ObjectField 
{
	List<DbField> fields = [];
	bool viewMode = false;
	

	void addValueToObjectFiled(String key, String value) =>
		object[key] = value;

	String getValueOfObjectField(key)
	{
		String value = '';

		try{
			value = object[key];
		}
		catch(e){}

		return value;
	}

	@Input('viewMode')
	void set setViewMode(bool value) => viewMode = value;

	@Input()
	dynamic object;

	@Input()
	void set options(List<DbField> value) => fields = value;
}
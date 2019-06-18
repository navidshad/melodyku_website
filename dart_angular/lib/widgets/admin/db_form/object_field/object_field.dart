/// {@nodoc}
library objectField;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector:'object-field',
	templateUrl: 'object_field.html',
	styleUrls: ['object_field.css'],
	directives: [
		coreDirectives,
		formDirectives,
		ObjectField,
		SelectField,
		MultiselectFeld,
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
	Map object;

	@Input()
	void set options(List<DbField> value) => fields = value;

	@Input()
	bool showHidenField;

	bool getAccessToShow(DbField item)
	{
		bool key = false;

		if(!item.isHide || showHidenField)
			key = true;

		return key;
	}
}
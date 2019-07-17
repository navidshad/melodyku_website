/// {@nodoc}
library selectField;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:async';

import 'package:melodyku/mongodb/mongodb.dart';

@Component(
	selector:'select-field',
	templateUrl: 'select_field.html',
	styleUrls: ['select_field.css'],
	directives: [
		coreDirectives,
		formDirectives,
	]
)
class SelectField
{
	List<DbField> fields = [];

	final _onChange = StreamController<String>();

	void changeValue(String value) => _onChange.add(value);

	@Input()
	String field;

	@Input()
	void set options(List<DbField> value) => fields = value;

	@Output()
	Stream<String> get onChange => _onChange.stream;

	bool chackNullObject()
	{
		if(field == null) field = '';
		return true;
	}
}
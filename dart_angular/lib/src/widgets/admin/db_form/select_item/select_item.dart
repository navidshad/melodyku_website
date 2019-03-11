import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import '../../../../class/utility/collection_options.dart';

@Component(
	selector:'select-item',
	templateUrl: 'select_item.html',
	styleUrls: ['select_item.scss.css'],
	directives: [
		coreDirectives,
		formDirectives,
	]
)
class SelectItem 
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
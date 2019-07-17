import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/mongodb/mongodb.dart';

@Component(
	selector: 'multiselect-field',
	templateUrl: 'multiselect_field.html',
	styleUrls: ['multiselect_field.css'],
	directives: [
		coreDirectives,
		formDirectives,
	]
)
class MultiselectFeld
{ 
	MultiselectFeld();

	@Input()
	List<String> selected;

	@Input()
	List<DbField> groups;

	void select(String value)
	{
		if(selected.indexOf(value) == -1)
			selected.add(value);
		else selected.remove(value);
	}

	bool checkStatus(String value)
	{
		if(selected.indexOf(value) == -1) return false;
		else return true;
	}
}
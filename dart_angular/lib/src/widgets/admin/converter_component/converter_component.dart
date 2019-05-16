import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/classes.dart';
import 'package:melodyku/src/widgets/admin/db_form/select_field/select_field.dart';

@Component(
	selector: 'converter',
	templateUrl: 'converter_component.html',
	styleUrls: ['converter_component.css'],
	directives: [
		coreDirectives,
		SelectField,
	]
)
class ConverterComponent 
{
	LanguageService lang;
	StitchService _stitch;

	ResultWithNavigator<Song> navigator;
	List<DbField> presets = [];
	String selectedPreset;
	bool isConverting = false;

	ConverterComponent(this.lang, this._stitch)
	{
		navigator = ResultWithNavigator<Song>();
		_getPresets();
	}

	void _getPresets() async
	{
		RemoteMongoCollection presetColl = _stitch.dbClient.db('cms').collection('convert_preset');
		promiseToFuture(presetColl.find().asArray())
			.then((dynamic docs) 
			{
				docs.forEach((dynamic doc) {
					Map converted = convertToMap(doc, SystemSchema.convert_preset);
					DbField field = DbField(converted['title'], strvalue: converted['title']);
					presets.add(field);
				});
			});
	}

	void convertAll()
	{
		if(isConverting) return;

		isConverting = true;
	}

	void stop()
	{
		if(!isConverting) return;

		isConverting = false;
	}

	void onSelectPreset(String title)
	{

	}
}
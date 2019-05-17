import 'package:angular/angular.dart';
import 'dart:html';

import 'package:socket_io_client/socket_io_client.dart' as IO;

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
	IO.Socket socket;

	ResultWithNavigator<Song> navigator;
	List<DbField> presets = [];
	List<String> logs = [];
	String selectedPreset;
	bool isConverting = false;

	ConverterComponent(this.lang, this._stitch)
	{
		navigator = ResultWithNavigator<Song>(perPage: 10);
		_getPresets();
		connectToSocket();
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
		if(isConverting || selectedPreset == null) return;

		isConverting = true;
		socket.emit('convertAll', selectedPreset);
	}

	void stop()
	{
		if(!isConverting) return;

		isConverting = false;
		socket.emit('stopConvert');
	}

	void onSelectPreset(String title)
	{
		selectedPreset = title;
		Map query = { 'versions.title': { '\$ne': title } };
		navigator.customQuery = query;
		navigator.loadNextPage(1);
	}

	void connectToSocket()
	{
		String orgine = window.location.origin.toString();
		socket = IO.io(orgine);
		socket.on('connect', (_) {
		  print('connected to socket');
		  socket.emit('getConverterStatus');
		});

		socket.on('getConverterStatus', (result) => isConverting = result['isConverting']);
		socket.on('onConvertReport', (msg) {
				logs.add(msg);
				logs = logs.reversed.toList();
			});
	}

	void clearLog() => logs = [];
}
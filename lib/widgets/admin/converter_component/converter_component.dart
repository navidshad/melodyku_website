/// {@nodoc}
library converterComponent;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

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
	MongoDBService _mongodb;
	IO.Socket socket;

	ResultWithNavigator<Song> navigator;
	List<Song> list= [];

	List<DbField> presets = [];
	List<String> logs = [];
	String selectedPreset;
	bool isConverting = false;

	ConverterComponent(this.lang, this._mongodb)
	{
		_getPresets();
		connectToSocket();
	}

	void _getPresets() async
	{
		_mongodb.find(database: 'cms', collection: 'convert_preset')
			.then((dynamic docs) 
			{
				docs.forEach((dynamic doc) {
					Map converted = validateFields(doc, SystemSchema.convert_preset);
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
		list = [];
		Map query = { 'versions.title': { '\$ne': title } };

		navigator = ResultWithNavigator<Song>(
			perPage: 10, customQuery: query);

		navigator.initialize();
		navigator.loadNextPage(goto:1, resetList: true)
			.then((songs) => list = songs);
	}

	void connectToSocket()
	{
		String orgine = Vars.host;
		socket = IO.io(orgine);
		socket.on('connect', (_) {
		  print('connected to socket');
		  socket.emit('getConverterStatus');
		});

		socket.on('getConverterStatus', (result) => isConverting = result['isConverting']);
		socket.on('onConvertReport', (msg) => logs.add(msg));
	}

	void clearLog() => logs = [];
}
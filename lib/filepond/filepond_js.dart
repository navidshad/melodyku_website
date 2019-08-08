@JS()
library main;

import 'package:js/js.dart';

external dynamic get FilePondPluginFileMetadata;

@JS()
@anonymous
class FilePond
{
	external static void registerPlugin(dynamic plugin);
	external static void setOptions(dynamic options);
	external static FilePondInstance create(dynamic inputElement);
}

@JS()
abstract class Process 
{
	external String get method;
	external Map get headers;

	external set onload(void Function(dynamic res) callback);
	external set onerror(void Function(dynamic body) callback);
	external set ondata(void Function(dynamic formdata) callback);
}

@JS()
abstract class Server {

	@JS()
	String url;

	@JS()
	Process process;
}

@JS()
abstract class FilePondInstance
{
	@JS()
	String name;

	@JS()
	bool disabled;

	@JS()
	bool allowDrop;

	@JS()
	bool allowBrowse;

	@JS()
	bool allowPaste;

	@JS()
	bool allowMultiple;

	@JS()
	int maxFiles;

	@JS()
	int maxParallelUploads;

	@JS()
	bool checkValidity;

	@JS()
	Server server;

	@JS()
	void on(String event, void Function(Map error, dynamic file) callback);

	external void setOptions(dynamic options);
	external void removeFiles();
}
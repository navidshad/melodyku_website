@JS()
library main;

import 'package:js/js.dart';

external dynamic get FilePondPluginFileMetadata;

@JS()
class FilePond
{
	external static void registerPlugin(dynamic plugin);
	external static void setOptions(dynamic options);
	external static FilePondInstance create(dynamic inputElement);
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

	external void setOptions(dynamic options);
}
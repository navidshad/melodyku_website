@JS()
library main;

export 'package:js/js_util.dart';
import 'package:js/js.dart';


@JS('location.reload')
external void reloadPage([bool clear]);

@JS('console.log')
external void log(dynamic msg);
/// {@nodoc}
@JS()
library main;

import 'package:js/js.dart';

// ==============================================
// stitch_interop
// ==============================================
typedef R Func1<A, R>(A a);

@JS('Promise')
class PromiseJsImpl<T> extends ThenableJsImpl<T> {
  external PromiseJsImpl(Function resolver);
  external static PromiseJsImpl<List> all(List<PromiseJsImpl> values);
  external static PromiseJsImpl reject(error);
  external static PromiseJsImpl resolve(value);
}

@anonymous
@JS()
abstract class ThenableJsImpl<T> {
  @anonymous
  external ThenableJsImpl JS$catch([Func1 onReject]);
  external ThenableJsImpl then([Func1 nResolve, Func1 onReject]);
}

@JS('Object')
class Objectjs {
	external static List<String> keys(dynamic object);
	external static List<dynamic> valus(dynamic object);
}

@JS('Date')
class JSDate{

	external factory JSDate(int year, int monthIndex, [int day, int hours, int minutes, int seconds]);

	external int getFullYear();
	external int getMonth();
	external int getDate();
	external int getHours();
	external int getMinutes();
	external int getSeconds();
}

@JS('console.log')
external void log(dynamic input);

@JS('JSON')
class JSON {
	external static String stringfy(jsObject);
}
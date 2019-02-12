import 'package:js/js.dart';

import './stitch_interop.dart';

@JS()
abstract class RemoteMongoReadOperation {
  external PromiseJsImpl<List<dynamic>> asArray();
  external PromiseJsImpl<dynamic> first();
  external PromiseJsImpl<RemoteMongoCursor> iterator();
  external PromiseJsImpl<List<dynamic>> toArray();
}

@JS()
abstract class RemoteMongoCursor {
  external void next();
}
import 'package:js/js.dart';

import '../interfaces/remoteMongoDatabase.dart';
export '../interfaces/remoteMongoDatabase.dart';

@JS()
class RemoteMongoClient
{
  external static dynamic get factory;
  external RemoteMongoDatabase db(String name);
}
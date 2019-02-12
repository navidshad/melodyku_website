import 'package:js/js.dart';
import '../interfaces/remoteMongoCollection.dart';

@JS()
abstract class RemoteMongoDatabase {
  external String get name;
  external RemoteMongoCollection collection(String name);
}
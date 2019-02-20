import 'package:js/js.dart';

import '../class/stitch_interop.dart';
import '../class/remoteMongoReadOperation.dart';

@JS()
abstract class RemoteMongoCollection {
  external String get namespace;

  external RemoteMongoReadOperation               aggregate(dynamic pipeline);
  external PromiseJsImpl<int>                     count([dynamic query, RemoteCountOptions options]);
  external PromiseJsImpl<RemoteDeleteResult>      deleteMany(dynamic query);
  external PromiseJsImpl<RemoteDeleteResult>      deleteOne(dynamic query);
  external RemoteMongoReadOperation               find([dynamic query, dynamic options]);
  external PromiseJsImpl<RemoteInsertManyResult>  insertMany(dynamic documents);
  external PromiseJsImpl<RemoteInsertOneResult>   insertOne(dynamic documents);
  external PromiseJsImpl<RemoteUpdateResult>      updateMany(dynamic query, dynamic update, [RemoteUpdateOptions updateOptions]);
  external PromiseJsImpl<RemoteUpdateResult>      updateOne(dynamic query, dynamic update, [RemoteUpdateOptions updateOptions]);
}

@JS()
abstract class RemoteDeleteResult {
  external int get deletedCount;
}

@JS()
abstract class RemoteInsertManyResult {
  external dynamic get insertedIds;
}

@JS()
abstract class RemoteInsertOneResult {
  external dynamic get insertedId;
}

@JS()
abstract class RemoteUpdateResult {
  external int get matchedCount;
  external int get modifiedCount;
  external dynamic get upsertedId;
}

@JS()
class RemoteCountOptions {
  external factory RemoteCountOptions(int limit);
}

@JS()
class RemoteFindOptions {
  external factory RemoteFindOptions({int limit, dynamic projection, dynamic sort});
}

@JS()
class RemoteUpdateOptions {
  external factory RemoteUpdateOptions({bool upsert});
}
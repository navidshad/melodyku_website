import 'dart:indexed_db';
import 'dart:html';

import 'package:melodyku/indexeddb/indexeddb.dart';

export 'dart:indexed_db';

class IndexedDBService
{
	bool isSupport = false;

	IndexedDBService()
	{
		isSupport = IdbFactory.supported;	
	}

	Future<dynamic> getStorageQuotaInfo()
	{
		return window.navigator.storage.estimate();
	}

	Future<Database> getDatabase(String name)
	{
		return window.indexedDB.open(name, version:1, onUpgradeNeeded: onUpgreade[name]);
	}	

	Future<ObjectStore> getCollection(String dbName, String collName)
	{
		return getDatabase(dbName)
			.then((db) => db.transaction(collName, 'readwrite').objectStore(collName));
	}

	Future<dynamic> getOne(String dbName, String collName, dynamic key)
	{
		return getCollection(dbName, collName)
			.then((coll) => coll.getObject(key));
	}

	Future<dynamic> insertOne(String dbName, String collName, dynamic doc)
	{
		return getCollection(dbName, collName)
			.then((coll) => coll.add(doc));
	}

	Future<dynamic> removeOne(String dbName, String collName, String id)
	{
		return getCollection(dbName, collName)
			.then((coll) => coll.delete(id));
	}
}
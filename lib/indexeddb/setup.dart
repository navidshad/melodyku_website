import 'dart:indexed_db';

Map<String, dynamic> onUpgreade = 
{

	'media': (VersionChangeEvent vce) 
	{
		// get database
		Database db = vce.target.result;

		// create song collections
		if(!db.objectStoreNames.contains('song'))
		{
			ObjectStore song = db.createObjectStore('song', keyPath: '_id');
			song.createIndex('_id', '_id', unique: true);
		}

		// create song collections
		if(!db.objectStoreNames.contains('file'))
		{
			ObjectStore songFile = db.createObjectStore('file', keyPath: '_id');
			songFile.createIndex('_id', '_id', unique: true);
		}
	}
};
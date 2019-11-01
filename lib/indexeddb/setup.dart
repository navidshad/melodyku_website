import 'dart:indexed_db';

ObjectStore createObjectStore(Database db, String name, {String keyPath})
{
  ObjectStore os;

  if(keyPath != null){
    os = db.createObjectStore(name, keyPath: keyPath);
    os.createIndex(keyPath, keyPath, unique: true);
  }
  else os = db.createObjectStore(name);

  return os;  
}

Map<String, dynamic> onUpgreade = 
{

	'media': (VersionChangeEvent vce) 
	{
    print('== onUpgreade');
		// get database
		Database db = vce.target.result;

		// create song collections
		if(!db.objectStoreNames.contains('song'))
		{
      createObjectStore(db, 'song', keyPath:'_id');
		} else {
      db.deleteObjectStore('song');
      createObjectStore(db, 'song', keyPath:'_id');
    }

    if(!db.objectStoreNames.contains('album'))
		{
      createObjectStore(db, 'album', keyPath:'_id');
		} else {
      db.deleteObjectStore('album');
      createObjectStore(db, 'album', keyPath:'_id');
    }

    if(!db.objectStoreNames.contains('artist'))
		{
      createObjectStore(db, 'artist', keyPath:'_id');
		} else {
      db.deleteObjectStore('artist');
      createObjectStore(db, 'artist', keyPath:'_id');
    }

		// create song collections
		if(!db.objectStoreNames.contains('file'))
		{
      createObjectStore(db, 'file');
		} else {
      db.deleteObjectStore('file');
      createObjectStore(db, 'file');
    }
	}
};
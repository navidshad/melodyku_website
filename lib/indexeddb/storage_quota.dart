import 'package:js/js_util.dart';
import 'dart:html';

import 'package:melodyku/services/services.dart';

class StorageQuta 
{
	double quota;
	double usage;
	double remain;
	bool isPersisted = false;

	IndexedDBService _idb;

	StorageQuta(this._idb, {this.quota=0, this.usage=0})
	{
		updateInfo();
	}

	Future<void> updateInfo() async
	{
		usage = 0;

		// calculate stored songs
		// await _idb.getCollection('media', 'song')
		// .then((songColl) 
		// {
		// 	songColl.openCursor()
		// 	.listen((CursorWithValue cursor) 
		// 	{
		// 		if(cursor != null) cursor.next();
		// 		else return;

		// 		usage += cursor.value['size'] / 1000;
		// 	});
		// });

		String origin = window.location.origin;
		if(origin.contains('melodyku') || origin.contains('localhost'))
		{
			// check if app has been persisted already
			isPersisted = await window.navigator.storage.persisted();

			if(!isPersisted)
				isPersisted = await window.navigator.storage.persist();

			// get quota
			await window.navigator.storage.estimate()
			.then((obj) 
			{
				quota = obj['quota'];//((obj['quota'] as double) ~/ 1000000).toInt();
				usage = obj['usage'];//((obj['usage'] as double) / 1000000);
				remain = quota - usage;
			});

			// calculate remain storage
			remain = quota - usage;
		}
	}

	Map getInfoMap(){
		return {
			'quota':quota,
			'usage':usage,
			'isPersisted': isPersisted,
		};
	}

	int getUsedPercentage() => (usage*100~/quota).toInt();
}
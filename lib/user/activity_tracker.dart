/// {@nodoc}
library activityTracker;

import 'package:js/js_util.dart' as js;
import 'dart:async';
import 'dart:html';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

enum TrackAction {play, like}

class ActivityTracker 
{
	//StitchService _stitch;
	// RemoteMongoDatabase _userDB;

	StitchClonerService _stitchCloner;
	String _userId;

	int _todayPlayCount = 0;
	int get todayPlayCount => _todayPlayCount;

	ActivityTracker(this._userId)
	{
		// _stitch = Injector.get<StitchService>();
		// _userDB = _stitch.dbClient.db('user');

		_stitchCloner = Injector.get<StitchClonerService>();

		_getTodayCount();
	}

	Future<void> reportPlayedSong(Song song) async
	{
		String collName = 'song_history';

		Map recentDoc = {
			'date' 		: DateTime.now().toUtc().toIso8601String(), //dateTimeToJSDate(DateTime.now()),
			'songId'	: song.id,
			'artistId'	: song.artistId,
			'refId'		: _userId,
		};

		// dynamic doc = js.jsify(recentDoc);

		// await promiseToFuture(_userDB.collection(collName).insertOne(doc))
		// .then((result) 
		// {
		// 	print('a played song has been reported $result');
		// 	_todayPlayCount++;
		// });

		await _stitchCloner.insertOne(
			collection: collName, doc: recentDoc)
			.then((result) 
			{
				print('a played song has been reported');
				_todayPlayCount++;
			});
	}

	Future<bool> reportLikedSong(Song song) async 
	{
		String collName = 'song_favorite';
		bool isTracked = false;

		// check if already added
		dynamic query = { 'songId': song.id, 'refId': _userId };
		
		int count = 0;

		//count = await promiseToFuture(_userDB.collection(collName).count(js.jsify(query)));

		count = await _stitchCloner.count(collection: collName, query: query);

		// like
		if(count == 0)
		{
			//print('=== begin to added new doc');
			Map recentDoc = {
				'date' 		: DateTime.now().toUtc().toIso8601String(), //dateTimeToJSDate(DateTime.now()),
				'songId'	: song.id,
				'artistId'	: song.artistId,
				'refId'		: _userId,
			};

			// dynamic doc = js.jsify(recentDoc);

			// await promiseToFuture(_userDB.collection(collName).insertOne(doc))
			// .then((result) {
			// 	print('a song has been liked');
			// 	isTracked = true;
			// });

			await _stitchCloner.insertOne(
			collection: collName, doc: recentDoc)
			.then((result) 
			{
				print('a song has been liked');
			 	isTracked = true;
			});
		}

		// unlike
		else {
			// await promiseToFuture(_userDB.collection(collName).deleteOne(query))
			// .then((result) {
			// 	isTracked = false;
			// 	print('a played song has been unliked');
			// })
			// .catchError((error) => isTracked = true);

			await _stitchCloner.removeOne(
				collection: collName, query: query)
				.then((result) {
					isTracked = false;
					print('a played song has been unliked');
				})
				.catchError((error) => isTracked = true);
		}

		//print('=== tracked song ${song.id} $isTracked');
		return isTracked;
	}

	Future<bool> getLikeStatus(String id, {ArchiveTypes type}) async 
	{
		String collName;
		bool result = false;

		if(type == ArchiveTypes.media) 
			collName = 'song_favorite';

		//RemoteMongoCollection collection = _userDB.collection(collName);

		dynamic query = {
				'songId': id,
				'refId'	: _userId
			};

		int count = 0;

		//count = await promiseToFuture(collection.count(js.jsify(query)));

		count = await _stitchCloner.count(collection: collName, query: query);

		//print('=== count for song $id is $count');

		if(count > 0) result = true; 

		return result;
	}

	Future<void> _getTodayCount() async
	{
		print('=== _getTodayCount');

		DateTime from = DateTime.now().toUtc();
		from = from.subtract(Duration(hours: from.hour, minutes: from.minute, seconds: from.second));

		dynamic pipeline = [
			{
				'\$match': {
					'date': {
						'\$gte'	: from.toIso8601String() //dateTimeToJSDate(from),
					}
				}
			},
		];

		// await promiseToFuture(_userDB.collection('song_history').aggregate(js.jsify(pipeline)).asArray())
		// .then((list) 
		// {
		// 	_todayPlayCount = list.length; 
		// 	//print('=== _getTodayCount ${_todayPlayCount}');
		// }).catchError((error) {
		// 	print('=== _getTodayCount $error');
		// });

		await _stitchCloner.aggregate(
			collection: 'song_history', piplines: pipeline)
			.then((list) 
			{
				_todayPlayCount = list.length; 
				print('=== _getTodayCount ${_todayPlayCount}');
			}).catchError((error) {
				print('=== _getTodayCount $error');
			});
	}
}

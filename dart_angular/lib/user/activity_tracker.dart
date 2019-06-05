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
	StitchService _stitch;
	RemoteMongoDatabase _userDB;
	String _userId;

	int _todayPlayCount = 0;
	int get todayPlayCount => _todayPlayCount;

	ActivityTracker(this._userId)
	{
		_stitch = Injector.get<StitchService>();
		_userDB = _stitch.dbClient.db('user');

		_getTodayCount();
	}

	Future<void> reportPlayedSong(Song song) async
	{
		String collName = 'song_history';

		Map recentDoc = {
			'date' 		: dateTimeToJSDate(DateTime.now()),
			'songId'	: song.id,
			'artistId'	: song.artistId,
			'refId'		: _userId,
		};

		dynamic doc = js.jsify(recentDoc);

		await promiseToFuture(_userDB.collection(collName).insertOne(doc))
		.then((result) 
		{
			print('a played song has been reported $result');
			_todayPlayCount++;
		});
	}

	Future<bool> reportLikedSong(Song song) async 
	{
		String collName = 'song_favorite';
		bool isTracked = false;

		// check if already added
		dynamic query = js.jsify({ 'songId': song.id, 'refId': _userId });
		//print('=== check if already added');
		int count = await promiseToFuture(_userDB.collection(collName).count(query));

		// like
		if(count == 0)
		{
			//print('=== begin to added new doc');
			Map recentDoc = {
				'date' 		: dateTimeToJSDate(DateTime.now()),
				'songId'	: song.id,
				'artistId'	: song.artistId,
				'refId'		: _userId,
			};

			dynamic doc = js.jsify(recentDoc);

			await promiseToFuture(_userDB.collection(collName).insertOne(doc))
			.then((result) {
				print('a song has been liked');
				isTracked = true;
			});
		}

		// unlike
		else {
			await promiseToFuture(_userDB.collection(collName).deleteOne(query))
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

		RemoteMongoCollection collection = _userDB.collection(collName);

		dynamic query = js.jsify({
				'songId': id,
				'refId'	: _userId
			});

		int count = await promiseToFuture(collection.count(query));

		//print('=== count for song $id is $count');

		if(count > 0) result = true; 

		return result;
	}

	Future<int> _getTodayCount() async
	{
		print('=== _getTodayCount');

		DateTime from = DateTime.now();
		from = from.subtract(Duration(hours: from.hour, minutes: from.minute, seconds: from.second));

		dynamic pipeline = js.jsify([
			{
				'\$match': {
					'date': {
						'\$gte'	: dateTimeToJSDate(from),
					}
				}
			},
		]);

		await promiseToFuture(_userDB.collection('song_history').aggregate(pipeline).asArray())
		.then((list) 
		{
			_todayPlayCount = list.length; 
			//print('=== _getTodayCount ${_todayPlayCount}');
		}).catchError((error) {
			print('=== _getTodayCount $error');
		});
	}
}

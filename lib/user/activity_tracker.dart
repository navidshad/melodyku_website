/// {@nodoc}
library activityTracker;

import 'dart:async';

import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

enum TrackAction {play, like}

class ActivityTracker 
{
	//StitchService _stitch;
	// RemoteMongoDatabase _userDB;

	MongoDBService _mongodb;
	String _userId;

	int _todayPlayCount = 0;
	int get todayPlayCount => _todayPlayCount;

	ActivityTracker(this._userId)
	{
		// _stitch = Injector.get<StitchService>();
		// _userDB = _stitch.dbClient.db('user');

		_mongodb = Injector.get<MongoDBService>();

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

		await _mongodb.insertOne( database: 'user', collection: collName, doc: recentDoc)
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

		count = await _mongodb.count(database: 'user', collection: collName, query: query);

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

			await _mongodb.insertOne(database: 'user', collection: collName, doc: recentDoc)
			.then((result) 
			{
				print('a song has been liked');
			 	isTracked = true;
			});
		}

		// unlike
		else {
			await _mongodb.removeOne(database: 'user', collection: collName, query: query)
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

		dynamic query = {
				'songId': id,
				'refId'	: _userId
			};

		int count = 0;
		count = await _mongodb.count(database: 'user', collection: collName, query: query);

		//print('=== count for song $id is $count');

		if(count > 0) result = true; 

		return result;
	}

	Future<void> _getTodayCount()
	{
		DateTime from = getDate(DateTime.now().toUtc());
	
		return getTotalActivity(collection: 'song_history', from: from)
			.then((count)
			{
				_todayPlayCount = count;
				print('=== _getTodayCount ${_todayPlayCount}');
			}).catchError((error) {
				print('=== _getTodayCount $error');
			});
	}

	Future<dynamic> getTotalActivity({String collection, DateTime from})
	{
		Map accessQuery = {'refId': _userId};
	
		dynamic pipeline = [
			{
				'\$match': accessQuery
			},
			{
				'\$match': {
					'date': {
						'\$gte'	: from.toIso8601String() //dateTimeToJSDate(from),
					}
				}
			},
			{ 
				'\$group': { '_id': null, 'count': {'\$sum':1} }
			}
		];

		List<TypeCaster> typeCasters = [
			TypeCaster('Date', '1.\$match.date.\$gte')
		];

		return _mongodb.aggregate(
			database: 'user', collection: collection, 
			piplines: pipeline, accessQuery: accessQuery,
			bodyKey: 'piplines', types: typeCasters)
			.then((list) {
				//print(list);
				return (list.length > 0) ? list[0]['count'] : 0;
			})
			.catchError((error) {
				print('=== getTotalActivity $error');
			});
	}
}

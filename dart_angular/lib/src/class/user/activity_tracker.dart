import 'package:js/js_util.dart' as js;
import 'dart:async';

import 'package:melodyku/src/class/classes.dart';
import 'package:melodyku/src/services/services.dart';

enum TrackAction {play, like}

class ActivityTracker 
{
	StitchService _stitch;
	String _userId;

	int _todayPlayCount = 0;
	int get todayPlayCount => _todayPlayCount;

	ActivityTracker(this._userId)
	{
		_stitch = Injector.get<StitchService>();
	}

	Future<bool> trackSong(Song song, {TrackAction action}) async 
	{
		String collName;

		if(action == TrackAction.like) 			collName = 'song_favorite';
		else if (action == TrackAction.play) 	collName = 'song_history';

		bool isTracked = false;

		// check if already added
		dynamic query = js.jsify({ 'songId': song.id, 'refId': _userId });
		//print('=== check if already added');
		int count = await promiseToFuture(_stitch.dbClient.db('user').collection(collName).count(query));

		// added new doc
		if(count == 0)
		{
			//print('=== begin to added new doc');
			Map recentDoc = {
				'date' 		: DateTimeToMap(DateTime.now().toUtc()),
				'songId'	: song.id,
				'artistId'	: song.artistId,
				'refId'		: _userId,
			};

			dynamic doc = js.jsify(recentDoc);
			dynamic dateArrayKeys = js.jsify(['date']);	

			await promiseToFuture(
				_stitch.appClient
					.callFunction('useCRUDForDatedObject', ['user', collName, 'insert', doc, dateArrayKeys])
			).then((result) {
				//print('a song has been tracked ${action.toString()}');
				isTracked = true;
			});
		}
		else isTracked = true;

		// increase todayPlayCount
		if(isTracked && action == TrackAction.play)
			_todayPlayCount++;

		//print('=== tracked song ${song.id} $isTracked');
		return isTracked;
	}

	Future<bool> getLikeStatus(String id, {ArchiveTypes type}) async 
	{
		String collName;
		bool result = false;

		if(type == ArchiveTypes.media) 
			collName = 'song_favorite';

		RemoteMongoCollection collection = _stitch.dbClient.db('user').collection(collName);

		dynamic query = js.jsify({
				'songId': id,
				'refId'	: _userId
			});

		int count = await promiseToFuture(collection.count(query));

		//print('=== count for song $id is $count');

		if(count > 0) result = true; 

		return result;
	}
}

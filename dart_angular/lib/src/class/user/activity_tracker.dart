import 'package:js/js_util.dart' as js;

import 'package:melodyku/src/class/classes.dart';
import 'package:melodyku/src/services/services.dart';

class ActivityTracker 
{
	StitchService _stitch;
	String _userId;

	ActivityTracker(this._userId)
	{
		_stitch = Injector.get<StitchService>();
	}

	void playSong(String songId)
	{
		Map recentDoc = {
			'date' 	: DateTimeToMap(DateTime.now().toUtc()),
			'songId': songId,
			'refId'	: _userId,
		};

		dynamic doc = js.jsify(recentDoc);
		dynamic dateArrayKeys = js.jsify(['date']);

		promiseToFuture(
			_stitch.appClient
				.callFunction('useCRUDForDatedObject', ['user', 'song_history', 'insert', doc, dateArrayKeys])
		).then((result) {
			print('a played song has been tracked');
		});
	}

	void likedSong(Song song)
	{

	}
}
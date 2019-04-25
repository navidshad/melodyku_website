import 'package:js/js_util.dart' as js;

import 'package:melodyku/src/services/stitch_service.dart';
import 'package:melodyku/src/class/injector.dart';

class Subscription 
{
	final String refId;

	String plan;
	DateTime startIn;
	DateTime expiresIn;

	StitchService _stitch;

	Subscription(this.refId)
	{
		this._stitch = Injector.get<StitchService>();
		getUserSubscription();

		expiresIn = DateTime.now().add(Duration(days: 1));
	}

	void getUserSubscription()
	{
		RemoteMongoCollection collection = _stitch.dbClient.db('user').collection('subscription');
		dynamic query = js.jsify({'refId': refId});
		
		promiseToFuture(collection.find(query).first())
			.then((result) 
			{
				
			})
			.catchError(_catchError);
	}

	bool hasSubscription()
	{
		bool key = false;

		if(expiresIn != null)
		{
			int difference = DateTime.now().difference(expiresIn).inMinutes;
			print('=== difference $difference');
			// future is less than now
			if(difference < 0) key = true;
		}

		return key;
	}

	void _catchError(error) => print(error);
}
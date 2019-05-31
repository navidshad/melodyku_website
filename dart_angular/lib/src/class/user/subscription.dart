import 'package:js/js_util.dart' as js;

import 'package:melodyku/src/class/archive/system_schema.dart';
import 'package:melodyku/src/services/services.dart';

class Subscription 
{
	final String refId;

	String plan;
	DateTime startsIn;
	DateTime expiresIn;

	StitchService _stitch;

	Subscription(this.refId)
	{
		this._stitch = Injector.get<StitchService>();
		getUserSubscription();
	}

	void getUserSubscription() async
	{
		RemoteMongoCollection collection = _stitch.dbClient.db('user').collection('subscription');
		dynamic query = js.jsify({'refId': refId});
		
		Future request = promiseToFuture(collection.find(query).first());

		_stitch.requestByQueue(request)
			.then((result) 
			{
				Map converted = convertToMap(result, SystemSchema.subscription);
				plan = converted['plan'];
				startsIn = converted['startsIn'];
				expiresIn = converted['expiresIn'] ?? DateTime.now();
			})
			.catchError(_catchError);
	}

	bool hasSubscription()
	{
		bool key = false;

		// check plan duration
		if(expiresIn != null)
		{
			int difference = DateTime.now().difference(expiresIn).inMinutes;
			//print('=== difference $difference');
			// future is less than now
			if(difference < 0) key = true;
		}
		// check dailly limitation
		else {
			UserService userService = Injector.get<UserService>();
			int todayPlayCount = userService.user.traker.todayPlayCount;
			if(todayPlayCount <= 3) key = true;
		}

		return key;
	}

	Duration getDurationLeft() =>
		expiresIn.difference(DateTime.now());

	void _catchError(error) => print(error);
}
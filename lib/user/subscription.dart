/// {@nodoc}
library subscrption;

import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Subscription 
{
	final String refId;

	String plan;
	DateTime startsIn;
	DateTime expiresIn;

	MongoDBService _mongodb;

	Subscription(this.refId)
	{
		this._mongodb = Injector.get<MongoDBService>();
		getUserSubscription();
	}

	void getUserSubscription() async
	{
		Map query = {'refId': refId };
    
		_mongodb.findOne(isLive:true, database: 'user', collection: 'subscription', query: query)
			.then((result) 
			{
				Map converted = validateFields(result, SystemSchema.subscription);
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
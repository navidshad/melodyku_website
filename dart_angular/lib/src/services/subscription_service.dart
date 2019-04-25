import 'dart:async';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/archive/system_schema.dart';

class SubscriptionService
{
	StitchService _stitch;
	List<Map> _tariffs = [];

	SubscriptionService(this._stitch);

	dynamic getByUser()
	{
		return null;
	}

	void submiteToUSer()
	{

	}

	Future<List<Map>> getTariffs() async
	{
		if(_tariffs.length == 0)
		{
			RemoteMongoCollection collection = _stitch.dbClient.db('cms').collection('tariffs');
			await promiseToFuture(collection.find().asArray())
				.then((result) 
				{
					result.forEach((doc) 
					{
						Map tariff = convertToMap(doc, SystemSchema.tariff);
						_tariffs.add(tariff);
					});
				})
				.catchError(_catchError);
		}

		return _tariffs;
	}

	void _catchError(error) => print(error);
}
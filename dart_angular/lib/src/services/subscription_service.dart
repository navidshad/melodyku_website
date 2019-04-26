import 'dart:async';
import 'dart:html';

import 'package:js/js_util.dart' as js;

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/archive/system_schema.dart';

class SubscriptionService
{
	StitchService _stitch;
	UserService _userService;
	List<Map> _tariffs = [];

	SubscriptionService(this._stitch, this._userService);

	Future<Map> getTariffById(String id) async
	{
		Map selectedTariff;
		List<Map> tempList = await getTariffs();
		tempList.forEach((t) 
		{
			if(t['_id'] == id) selectedTariff = t;
		});

		return selectedTariff;
	}

	void purchaseTariff(String id) async
	{
		String refId = _userService.user.id;
		Map tariff = await getTariffById(id);
		if(tariff == null) return;

		int daysDuration = tariff['days'];

		DateTime startsIn = DateTime.now();
		DateTime expiresIn = DateTime.now().add(Duration(days: daysDuration));

		dynamic newUserSubscriptionPlane = {
			'refId'		: refId,
			'plane'		: tariff['title'],
			'startsIn'	: startsIn.toString(),
			'expiresIn'	: expiresIn.toString(),
		};

		// update user SubscriptionService
		RemoteMongoCollection coll = _stitch.dbClient.db('user').collection('subscription');
		dynamic query = js.jsify({'refId':refId});
		promiseToFuture(coll.updateOne(query, js.jsify(newUserSubscriptionPlane)))
			.then((result) 
			{
				print('### tariff ${tariff['title']} has been submitted for user.');
				_userService.user.updateSubscription();
			})
			.catchError(_catchError);
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
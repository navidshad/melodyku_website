/// {@nodoc}
library subscriptionService;

import 'dart:async';
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/navigator.dart';
import 'package:melodyku/core/system_schema.dart';

class SubscriptionService
{
	MongoDBService _mongoDBService;
	UserService _userService;
	ModalService _modalService;
	List<Map> _tariffs = [];

	SubscriptionService(this._mongoDBService, this._userService, this._modalService);

	Future<Map> getTariffById(dynamic id) async
	{
		Map selectedTariff;
		List<Map> tempList = await getTariffs();
		tempList.forEach((t) 
		{
			if(t['_id'] == id) selectedTariff = t;
		});

		return selectedTariff;
	}

	// void purchaseTariff(dynamic id) async
	// {
	// 	String refId = _userService.user.id.toString();
	// 	Map tariff = await getTariffById(id);
	// 	if(tariff == null) return;

	// 	int daysDuration = tariff['days'];

	// 	DateTime startsIn = DateTime.now().toUtc();
	// 	DateTime expiresIn = DateTime.now().add(Duration(days: daysDuration)).toUtc();

	// 	Map newUserSubscriptionPlane = {
	// 		'refId'		: refId,
	// 		'plan'		: tariff['title'],
	// 		'startsIn'	: startsIn.toIso8601String(),
	// 		'expiresIn'	: expiresIn.toIso8601String(),
	// 	};

	// 	dynamic doc = {'\$set': newUserSubscriptionPlane};
	// 	dynamic query = {'refId':refId};

 //    _mongoDBService.updateOne(database: 'user', collection: 'subscription', 
 //      query: query, update: doc, options: {'upsert': true})
 //      .then((result)
	// 		{
	// 			print('### tariff ${tariff['title']} has been submitted for user.');
	// 			_userService.user.updateSubscription();
	// 		})
	// 		.catchError(_catchError);
	// }

	Future<List<Map>> getTariffs() async
	{
		if(_tariffs.length == 0)
		{
			await _mongoDBService.find(database: 'cms', collection: 'tariff')
				.then((result) 
				{
					result.forEach((doc) 
					{
						Map tariff = validateFields(doc, SystemSchema.tariff);
						_tariffs.add(tariff);
					});
				})
				.catchError(_catchError);
		}

		return _tariffs;
	}

	void goToSubscriptionPage()
	{
		if(!_userService.isLogedIn) _modalService.show('login');
		else Navigator.gotTo('subscription');
	}

	void _catchError(error) => print(error);
}
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
	PaymentService _payment;
	List<Map> _tariffs = [];

	SubscriptionService(this._mongoDBService, this._userService, this._payment);

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

	Future<List<Map>> getTariffs() async
	{
		if(_tariffs.length == 0)
		{
			await _mongoDBService.find(database: 'cms', collection: 'tariff')
				.then((result) 
				{
					result.forEach((doc) 
					{
						List<DbField> fields = SystemSchema.injectSubfields('currencies', SystemSchema.tariff, _payment.getCurrenciesDbFields());
						Map tariff = validateFields(doc, fields);
						_tariffs.add(tariff);
					});
				})
				.catchError(_catchError);
		}

		return _tariffs;
	}

	void goToSubscriptionPage()
	{
		if(!_userService.isLogedIn) Navigator.gotTo('login');
		else Navigator.gotTo('subscription');
	}

	void _catchError(error) => print(error);
}
/// {@nodoc}
library subscriptionPlansComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'subscription_plans',
	templateUrl: 'subscription_plans_component.html',
	styleUrls: ['subscription_plans_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		CardTariffComponent,
		DirectionDirective
	],
)
class SubscriptionPlansComponent 
{
	SubscriptionService _subService;
	PaymentService _payService;
	LanguageService lang;
	List<Map> tariffs = [];

	List<String> currencies = [];
	String currency = '';

	bool allowPayment = true;

	SubscriptionPlansComponent(this._subService, this._payService, this.lang)
	{
		prepare();
	}

	void prepare() async
	{
		currencies = _payService.currencies;
		
		if(currencies.length > 0)
			currency = currencies[0];

		getTariffsByCurrency();
	}

	void getTariffsByCurrency()
	{
		_subService.getTariffs()
		.then((list)
		{	if(currency == '') return;
			tariffs = list.where((doc) => doc['currencies'][currency]['isActive']).toList();
		});
	}

	void onChangeCurrency(String str)
	{
		currency = str;
		getTariffsByCurrency();
		print('onChangeCurrency $str');
		// if(str == 'irt') currency = Currency.irt;
		// else if(str == 'eur') currency = Currency.eur;
	}

	void _catchError(error) => print(error);
}
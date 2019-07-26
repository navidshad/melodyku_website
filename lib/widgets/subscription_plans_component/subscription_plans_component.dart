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
	LanguageService lang;
	List<Map> tariffs = [];

	Currency currency = Currency.irt;

	bool allowPayment = true;

	SubscriptionPlansComponent(this._subService, this.lang)
	{
		getTariffs();
	}

	void getTariffs() async
	{
		tariffs = await _subService.getTariffs();
	}

	void onChangeCurrency(String str)
	{
		print('onChangeCurrency $str');
		if(str == 'irt') currency = Currency.irt;
		else if(str == 'eur') currency = Currency.eur;
	}

	void _catchError(error) => print(error);
}
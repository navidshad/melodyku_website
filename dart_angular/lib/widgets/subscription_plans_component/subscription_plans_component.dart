/// {@nodoc}
library subscriptionPlansComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'subscription_plans',
	templateUrl: 'subscription_plans_component.html',
	styleUrls: ['subscription_plans_component.css'],
	directives: [
		coreDirectives,
		CardTariffComponent,
	]
)
class SubscriptionPlansComponent 
{
	SubscriptionService _subService;
	List<Map> tariffs = [];

	SubscriptionPlansComponent(this._subService)
	{
		getTariffs();
	}

	void getTariffs() async
	{
		tariffs = await _subService.getTariffs();
	}

	void _catchError(error) => print(error);
}
import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/widgets/card_tariff_component/card_tariff_component.dart';

@Component(
	selector: 'subscription_plans',
	templateUrl: 'subscription_plans_component.html',
	styleUrls: ['subscription_plans_component.scss.css'],
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
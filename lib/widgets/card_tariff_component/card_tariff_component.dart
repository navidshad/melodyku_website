/// {@nodoc}
library cardTariffComponent;

import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'card_tariff',
	templateUrl: 'card_tariff_component.html',
	styleUrls: ['card_tariff_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	]
)
class CardTariffComponent implements DoCheck
{
	LanguageService lang;
	UserService _userService;
	SubscriptionService _subService;

	CardTariffComponent(this.lang, this._userService, this._subService)
	{
		if(_userService.user.subscription.hasSubscription())
			active = false;
	}

	@override
	void ngDoCheck()
	{
		print('get price');
		if(currency == Currency.irt)
			price = '${detail['price_irt']} ${lang.getStr('irt')}';
		else if(currency == Currency.euro)
			price = '${detail['price_eur']} ${lang.getStr('eur')}';
	}

	String price = '';

	@Input()
	Map detail;

	@Input()
	Currency currency;

	bool active = true;


	void makePurchase()
	{
		if(!active) return;
		active = false;

		_subService.purchaseTariff(detail['_id']);
	}
}
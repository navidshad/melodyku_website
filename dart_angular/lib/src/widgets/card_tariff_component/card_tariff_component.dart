import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';

@Component(
	selector: 'card_tariff',
	templateUrl: 'card_tariff_component.html',
	styleUrls: ['card_tariff_component.scss.css'],
	directives: [
		coreDirectives,
	]
)
class CardTariffComponent 
{
	LanguageService lang;
	UserService _userService;
	SubscriptionService _subService;

	CardTariffComponent(this.lang, this._userService, this._subService)
	{
		if(_userService.user.subscription.hasSubscription())
			active = false;
	}

	@Input()
	Map detail;

	bool active = true;


	void makePurchase()
	{
		if(!active) return;
		active = false;

		_subService.purchaseTariff(detail['_id']);
	}
}
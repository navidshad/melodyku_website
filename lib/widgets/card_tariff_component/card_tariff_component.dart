/// {@nodoc}
library cardTariffComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'card_tariff',
	templateUrl: 'card_tariff_component.html',
	styleUrls: ['card_tariff_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		DirectionDirective,
		ElementExtractorDirective,
	]
)
class CardTariffComponent implements DoCheck
{
	LanguageService lang;
	UserService _userService;
	PaymentService _peymentService;

	SectionSwitcher switcher;

	List<Getway> getways = [];
	Getway selectedGate;

	CardTariffComponent(this.lang, this._userService, this._peymentService)
	{
		if(_userService.user.subscription.hasSubscription()){
			//active = false;
		}

		_peymentService.getWays()
			.then((list) {
				getways = list;
				selectedGate = getways[0];
			});
	}

	@override
	void ngDoCheck()
	{
		print('get price');
		if(currency == Currency.irt)
			price = '${detail['price_irt']} ${lang.getStr('irt')}';
		else if(currency == Currency.eur)
			price = '${detail['price_eur']} ${lang.getStr('eur')}';
	}

	String price = '';

	@Input()
	Map detail;

	@Input()
	Currency currency;

	bool active = true;


	void showPayform()
	{
		if(!active) return;
		active = false;

		//_subService.purchaseTariff(detail['_id']);

		switcher.show('s_payment');
	}

	void makePurchase()
	{
		_peymentService.createFactor(detail['_id'].toString(), selectedGate.currency)
			.then((factor) => factor.getPayLink(selectedGate.title))
			.then((String link) {
				Navigator.goToRawPath(link);
			});
	}

	void back()
	{
		active = true;
		switcher.show('s_tariff');
	}

	void getElement(HtmlElement el)
	{
		
		switcher = SectionSwitcher([
			el.querySelector('.s_tariff'),	
			el.querySelector('.s_payment'),	
		]);

		switcher.show('s_tariff');
	}

	void onChangeGetway(String gateTitle)
	{
		getways.forEach((getway) {
			if(getway.title == gateTitle)
				selectedGate = getway;
		});
	}
}
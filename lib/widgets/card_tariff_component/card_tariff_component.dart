/// {@nodoc}
library cardTariffComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'card_tariff',
	templateUrl: 'card_tariff_component.html',
	styleUrls: ['card_tariff_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		ElementExtractorDirective,
		ButtonRounded,
	]
)
class CardTariffComponent implements OnChanges
{
	LanguageService lang;
	UserService _userService;
	PaymentService _peymentService;

	SectionSwitcher switcher;
	ButtonOptions payBtnOptions;

	List<Getway> getways = [];
	Getway selectedGate;

	String price = '';

	@Input()
	Map detail;

	@Input()
	Currency currency;

	@Input()
	bool allowPayment;

	final _onChangeAllowPayment = StreamController<bool>();

	@Output()
	Stream<bool> get onChangeAllowPayment => _onChangeAllowPayment.stream;

	String paylink = '';

	CardTariffComponent(this.lang, this._userService, this._peymentService)
	{
		payBtnOptions = ButtonOptions(
				lable: lang.getStr('createFactor'), 
				type: ButtonType.sl,
				callback: makePurchase
			);
	}

	@override
	void ngOnChanges(Map<String, SimpleChange> changes)
	{
		payBtnOptions.setActivation(false);
		
		_peymentService.getWays(currency)
			.then((list) 
			{
				getways = list;
				if(list.length == 0) return;

				selectedGate = getways[0];
				payBtnOptions.setActivation(true);
			});

		if(currency == Currency.irt)
			price = '${detail['price_irt']} ${lang.getStr('irt')}';
		else if(currency == Currency.eur)
			price = '${detail['price_eur']} ${lang.getStr('eur')}';
	}

	void showPayform()
	{
		if(!allowPayment) return;
		
		_onChangeAllowPayment.add(false);
		switcher.show('s_payment');
	}

	void back()
	{
		_onChangeAllowPayment.add(true);
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

	Function openPaymentLink() {
		payBtnOptions.doWaiting(true);
		Navigator.goToRawPath(paylink);
	}

	Function makePurchase()
	{
		payBtnOptions.doWaiting(true);
		_peymentService.createFactor('tariff', detail['_id'].toString(), selectedGate.currency)
			.then((factor) => factor.getPayLink(selectedGate.title))
			.then((String link) 
			{
				paylink = link;
				payBtnOptions.lable = lang.getStr('pay');
				payBtnOptions.callback = openPaymentLink;
				payBtnOptions.doWaiting(false);
				payBtnOptions.setColor('green');
			});
	}
}
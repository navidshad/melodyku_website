import 'package:angular/angular.dart';

import 'package:melodyku/payment/payment.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'factor',
	templateUrl: 'factor_viewer_component.html',
	styleUrls: ['factor_viewer_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	]
)
class FactorViewerComponent implements OnChanges
{
	LanguageService lang;
	PaymentService _payment;

	@Input()
	String id;

	Factor factor;
	bool wasNotFound = false;

	FactorViewerComponent(this.lang, this._payment);

	void ngOnChanges(dynamic changes)
	{
		if(id == null) return;
		
		wasNotFound = false;
		factor = null;

		_payment.getFactor(id ?? 'no-id')
			.then((f) {
				if(f != null) factor = f;
				else wasNotFound = true;
			});
	}
}
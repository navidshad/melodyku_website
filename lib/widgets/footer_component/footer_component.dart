import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'footer-section',
	templateUrl: 'footer_component.html',
	styleUrls: ['footer_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	]
)
class FooterComponent
{
	LanguageService lang;

	FooterComponent(this.lang);

	bool get isInstalled => getInstallStatus();
  	void installApp() => installPWA();
}
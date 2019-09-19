import 'package:angular/angular.dart';

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
	AppshellService _appshell;

	FooterComponent(this.lang, this._appshell);

	bool get isInstalled => _appshell.getInstallSupportStatus();
  	void installApp() => _appshell.installPWA();

  	String getVersion() => _appshell.version;
}
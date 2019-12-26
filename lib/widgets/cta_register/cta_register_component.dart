import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/core/core.dart';

@Component(
    selector: 'register-cta',
    templateUrl: 'cta_register_component.html',
    styleUrls: [
      'cta_register_component.css'
    ],
    directives: [
      coreDirectives,
      DirectionDirective,
    ])
class CTARegisterComponent {
  UserService userService;
  LanguageService lang;
  AnalyticService _analytic;

  CTARegisterComponent(
      this.userService, this.lang, this._analytic);

  void onClick() {
    Navigator.gotTo('login', parameters:{'form': 'register-phone'});
    _analytic.trackEvent('clicked', category: 'CTA', label: 'Register');
  }
}

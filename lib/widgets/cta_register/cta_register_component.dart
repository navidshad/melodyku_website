import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

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

  CTARegisterComponent(this.userService, this.lang);
}

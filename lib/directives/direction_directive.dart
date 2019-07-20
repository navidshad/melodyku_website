import 'dart:html';

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart' as core;
import 'package:melodyku/services/services.dart';

@Directive(selector: '[direction]')
class DirectionDirective
{
	DirectionDirective(Element el)
	{
		LanguageService lang = core.Injector.get<LanguageService>();
		Direction direction = lang.getDirection();

		if(direction == Direction.ltr)
			el.setAttribute('dir', 'ltr');
		else el.setAttribute('dir', 'rtl');
	}
}
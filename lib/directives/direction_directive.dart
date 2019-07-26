import 'dart:html';
import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart' as core;
import 'package:melodyku/services/services.dart';

/*
* This is a directive 
* For controling RTL/LTR aspect of components
* */

@Directive(selector: '[direction]')
class DirectionDirective
{
	// called when element being created
	DirectionDirective(Element tag)
	{
		// get language service
		LanguageService lang = core.Injector
									.get<LanguageService>();
		
		// get global direction
		Direction direction = lang.getDirection();

		// set element direction
		if(direction == Direction.ltr)
			tag.setAttribute('dir', 'ltr');
		else tag.setAttribute('dir', 'rtl');
	}
}
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
	Element tag;
	// called when element being created
	DirectionDirective(Element tag)
	{
		this.tag = tag;
	}

	String dir;

	@Input()
	bool align;

	@Input()
	set direction(String val)
	{
		dir = val;
		tag.setAttribute('dir', dir);

		if((align ?? false)) tag.style.setProperty('text-align', getTextAlign());
	}

	String getTextAlign()
	{
		if(dir == 'ltr') return 'left';
		else return 'right';
	}
}
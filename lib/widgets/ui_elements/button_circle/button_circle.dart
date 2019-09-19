import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'circle-button',
	templateUrl: 'button_circle.html',
  	styleUrls: ['button_circle.css'],
  	directives: [
    	coreDirectives,
    	ElementExtractorDirective
  	],
)
class ButtonCircle implements OnChanges
{
	@Input()
	ButtonOptions options;

	@Input()
	dynamic arg;

	bool isWaiting = false;
	bool isActive = true;
	HtmlElement btnElement;

	void ngOnChanges(Map<String, SimpleChange> changes)
	{
		options.waitingController.stream
			.listen(doWaiting);

		options.colorController.stream
			.listen(setColor);

		options.statusController.stream
			.listen(setStatus);
	}

	void onClick()
	{
		if(isWaiting || !isActive) return;

    	print(options.hashCode);

		options.arg = arg;
		options.done();
	}

	void setStatus(bool key) =>
		isActive = key;

	void onEaxtractElement(HtmlElement el)
		=> btnElement = el;

	void doWaiting(bool key)
	{
		isWaiting = key;

		if(isWaiting) btnElement.classes.add('btn-disabled');
		else btnElement.classes.remove('btn-disabled');
	}

	void setColor(String color) =>
		btnElement.classes.add('btn-$color');
}
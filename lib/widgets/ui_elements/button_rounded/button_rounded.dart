import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'rounded-button',
	templateUrl: 'button_rounded.html',
  	styleUrls: ['button_rounded.css'],
  	directives: [
    	coreDirectives,
    	ElementExtractorDirective
  	],
)
class ButtonRounded implements OnInit
{
	@Input()
	ButtonOptions options;

	bool isWaiting = false;
	bool isActive = true;
	HtmlElement btnElement;

	void ngOnInit()
	{
		options.waitingController.stream
			.listen(doWaiting);

		options.colorController.stream
			.listen(setColor);

		options.statusController.stream
			.listen(setStatus);
	}

	void onClick(){
		if(isWaiting || !isActive) return;
		options.callback();
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
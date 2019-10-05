import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';

import 'dart:html';

@Component(
	selector: 'global-popup-presentor',
	templateUrl: 'global_popup_presentor.html',
	styleUrls: ['global_popup_presentor.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		PlaylistInjectorComponent,
		MediaPackInjectorComponent,
	]
)
class GlobalPopupPresentor
{
	PopupService _popupService;
	SectionSwitcher switcher;
	
	Element base;
	dynamic arg;
	String currentid = '';

	GlobalPopupPresentor(this._popupService)
	{
		_popupService.popupController.stream.listen(onAskToShowPopup);
		_popupService.popupCloser.stream.listen(onAskToClose);
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		base = el;

		switcher = SectionSwitcher(
		[
		  el.querySelector('#globalPlaylistInjector'),
		  el.querySelector('#globalMediaPackInjector'),
		]);
	}

	void onAskToClose(bool key)
	{
		switcher.hideAll().then((r) => currentid = '');

		base.style.display = 'none';
		base.style.opacity = '0';
	}

	void onAskToShowPopup(Map<String, dynamic> detail)
	{
		base.style.display = 'block';
		base.style.opacity = '1';

		detail.keys.forEach((key) {
			currentid = key;
			arg = detail[key];
		});

		switcher.show(currentid);
	}
}


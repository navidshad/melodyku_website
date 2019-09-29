import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'popup-menu',
	templateUrl: 'popup_menu_component.html',
	styleUrls: ['popup_menu_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	]
)
class PopMenuComponent 
{
	LanguageService lang;

	@Input()
	String type;

	@Input()
	String lable;

	@Input()
	String icon;

	@Input()
	bool reverse;

	@Input()
	List<PopupButtonOptions> popupButtons = [];

	bool isShowMenu = false;

	PopMenuComponent(this.lang);

	String getDir()
	{
		String dir = lang.getDir();

		if(reverse != null)
		{
			if(dir == 'ltr') dir = 'rtl';
			else dir = 'ltr';
		}

		return dir;
	}
}
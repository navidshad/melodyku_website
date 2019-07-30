import 'package:angular/angular.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/services/services.dart';

@Component(
	selector:'page',
	template: '''

	''',
	directives: [
		DbCollectionTableEditorComponent,
	]
)
class SlideShowsPage
{
	Page _page;
  	LanguageService lang;
  	UserService _userservice;
  	MessageService _messageService;

  	CollectionOptions options;

	SlideShowsPage(this.lang, this._messageService, this._userservice)
	{
		_page = Page(
		  userService: _userservice, 
		  messageService: _messageService, 
		  permissionType: PermissionType.customer_access,
		  needLogedIn: true,
		  title: 'history');

		options = new CollectionOptions(
				title: 'slide show list',
				database: 'cms',
				collection: 'slideshow',
				
			);
	}
}
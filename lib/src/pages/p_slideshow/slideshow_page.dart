import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/services/services.dart';

@Component(
	selector:'page',
	template: '<slideshow-editor [id]="id"></slideshow-editor>',
	directives: [
		coreDirectives,
		SlideShowEditorComponent,
	]
)
class SlideShowPage implements OnActivate 
{
	Page _page;
	LanguageService lang;
	UserService _userservice;
	MessageService _messageService;

	String id;

	CollectionOptions options;

	SlideShowPage(this.lang, this._messageService, this._userservice);

	@override
	void onActivate(_, RouterState current)
	{
    _page = Page(
		  userService: _userservice, 
		  messageService: _messageService, 
		  permissionType: PermissionType.customer_access,
		  needLogedIn: true,
		  title: 'slide show editor');
      
		id = current.parameters['_id'];
	}
}
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'page',
	template: 
	'''
	<div class="flex-column flex-center">
		<factor [id]="id"></factor>
	</div>
	''',
	directives: [
		FactorViewerComponent,
	]
)
class FactorPage implements OnActivate
{
	Page _page;
	LanguageService lang;
	UserService _userservice;
	MessageService _messageService;

	String id;

	// constructor ==================================
	FactorPage(this._messageService, this._userservice);

	@override
	void onActivate(_, RouterState current) async 
	{
    _page = Page(
		  userService: _userservice, 
		  messageService: _messageService, 
		  permissionType: PermissionType.customer_access,
		  needLogedIn: false,
		  title: 'factor',
		);
    
		id = current.parameters['id'];
	}
}
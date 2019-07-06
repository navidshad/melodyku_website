import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:html';
import 'dart:async';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'page',
	templateUrl: 'email_confirmation.html',
	styleUrls: [ 'email_confirmation.css' ],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
	]
)
class  EmailConfirmationPage implements OnActivate 
{
	Page _page;
	LanguageService lang;
	UserService _userservice;
	MessageService _messageService;
	StitchService _stitch;

	ModalService _modalService;
  	Modal modal;

	// constructor ==================================
	EmailConfirmationPage(this._messageService, this._userservice, this._stitch, this._modalService)
	{
		_page = Page(
			userService: _userservice, 
			messageService: _messageService, 
			permissionType: PermissionType.customer_access,
			needLogedIn: false,
			title: 'email_confirmation',
		);
	}

	// get and register modal to modal Manager
	void getElement(Element el) async
	{
		print('create modal');
		modal = Modal(el, onClose: Page.goToHome);

		_modalService.register('email_confirmation', modal);

		//show modal
		await Future.delayed(Duration(seconds: 1));

		modal.doWaiting(true);
		_modalService.show('email_confirmation');
	}

	//@override
	void onActivate(_, RouterState current) async 
	{
		final token = current.parameters['token'];
		final tokenID = current.parameters['tokenId'];
		

		// get 
		await _stitch.confirmEmail(token, tokenID)
		.then((result) async
		{
			modal.addMessage(lang.getStr('done'));
      		modal.showMessage();
      		modal.doWaiting(false);

			await Future.delayed(Duration(seconds: 1));
      		Page.goToHome();
		})
		.catchError((result) {
			modal.addMessage(lang.getStr('LinkInvalid'), color: 'red');
      		modal.showMessage();
      		modal.doWaiting(false);
		});	
	}
}
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:js/js_util.dart' as js;

import '../../../services/stitch_service.dart';
import '../../../services/modal_service.dart';

import '../../../class/user/permission.dart';
import '../../../class/user/user.dart';
import '../../../class/modal/modal.dart';

import '../../../directives/ElementExtractorDirective.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'user-manager',
	templateUrl: 'user_manager.html',
	styleUrls: ['user_manager.scss.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
	]
)
class UserManagerComponent 
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoDatabase _userdb;

	List<User> list = [];
	List<Permission> plist = [];

	int perPage = 5;
	int total = 0;
	int total_pages = 0;
	int current_page = 1;


	List<String> titles = [
		'NAME', 
		'EMAIL',
		'ACCESS',
		'OPTIONS',
	];

	User editable;
	String formType = 'add';

	UserManagerComponent(this._stitch, this._modalService)
	{
		_userdb = _stitch.dbClient.db('user');
		getPage();
		getPermissions();
	}

	void getPermissions() async
	{
		await promiseToFuture(_userdb.collection('permission').find().asArray())
		.then((documents) 
		{
			plist = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertFromJS(documents[i]);
				Permission pr = Permission.fromJson(detail);
				plist.add(pr);
			}
		});

		print('permission gotten, ${plist.length}');
	}

	dynamic getNavigatorDetail(int total, int page, int perPage)
	{
		int _total_pages = (total/perPage).toInt();
		if(page > _total_pages) page = 1;

		int from = 0;
		if(perPage == 1) from = page-1;
		else from = (perPage * page) - perPage;

		if (page <= 1) from = 0;

		Map result = {'from':from, 'to':perPage};
		return result;
	}

	void getPage([int page=1]) async
	{
		await promiseToFuture(_userdb.collection('detail').count())
		.then((count) {
			total = count;
		}).catchError(_catchError);


		Map avigatorDetail = getNavigatorDetail(total, page, perPage);

		dynamic pipline = js.jsify([
			{"\$skip": avigatorDetail['from']},
			{"\$limit": avigatorDetail['to']}
		]);

		await promiseToFuture(_userdb.collection('detail').aggregate(pipline).asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertFromJS(documents[i]);
				User user = User.fromJson(detail);
				list.add(user);
			}
		});

		print('users gotten, ${list.length}');
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modal = Modal(el);
		_modalService.register('edit_user', modal);
	}

	void showForm(User user)
	{
		editable = user;
		_modalService.show('edit_user');
	}

	void updateUser() async
	{
		modal.doWaiting(true);

		print('updating ${editable.id}');

		dynamic query = js.jsify({'refId': editable.id.toString()});

		dynamic update = js.jsify({
			'\$set': {
				'fullname': editable.fullname,
				'permissionName': editable.permissionName,
			}
		});

		await promiseToFuture(_userdb.collection('detail').updateOne(query, update))
		.then((d){
			print(convertFromJS(d));
			modal.close();
			getPage();
		})
		.catchError((error){
			print(error);
		});
	}

	void _catchError(error) => print(error);
}

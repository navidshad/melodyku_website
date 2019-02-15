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

	User newUser;
	String formType = 'add';

	UserManagerComponent(this._stitch, this._modalService)
	{
		_userdb = _stitch.dbClient.db('user');
		getPage();

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
		_modalService.register('add_permission', modal);
	}

	void showForm(String type, [User editable])
	{
		newUser = User('');
		formType = type;
		_modalService.show('add_permission');
	}

	void addNewPermission() async
	{
		

		// dynamic newPermission = js.jsify({

		// });

		// await promiseToFuture(_userdb.collection('permission').insertOne(newPermission))
		// .then((document) {
		// 	modal.close();
		// 	getPage();
		// })
		// .catchError((error){
		// 	print(error);
		// });		
	}

	void updatePermission() async
	{
		// modal.doWaiting(true);

		// print('updating ${newUser.id}');

		// dynamic query = js.newObject();
		// js.setProperty(query, '_id', newUser.id);

		// dynamic update = js.jsify({
		// 	'\$set': {

		// 	}
		// });

		// await promiseToFuture(_userdb.collection('permission').updateOne(query, update))
		// .then((d){
		// 	print(convertFromJS(d));
		// 	modal.close();
		// 	getPage();
		// })
		// .catchError((error){
		// 	print(error);
		// });
	}

	void deletePermission() async
	{
		// modal.doWaiting(true);

		// print('deleting ${newUser.id}');

		// dynamic query = js.newObject();
		// js.setProperty(query, '_id', newUser.id);

		// await promiseToFuture(_userdb.collection('permission').deleteOne(query))
		// .then((d){
		// 	print(convertFromJS(d));
		// 	modal.close();
		// 	getPage();
		// })
		// .catchError((error){
		// 	print(error);
		// });
	}

	void _catchError(error) => print(error);
}

import 'package:angular/angular.dart';
import 'dart:html';

import '../../../services/stitch_service.dart';

import '../../../class/user/permission.dart';

import '../dbCollection_table/dbCollection_table.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'user-manager',
	templateUrl: 'user_manager.html',
	styleUrls: ['user_manager.scss.css'],
	directives: [
		coreDirectives,
		DbCollectionTableComponent
	]
)
class UserManagerComponent 
{
	StitchService _stitch;
	RemoteMongoDatabase _userdb;

	// int perPage = 5;
	// int total = 0;
	// int total_pages = 0;
	// int current_page = 1;

	Map<String, dynamic> options = {
		'disables': <String>['email', 'refId'],
		"types" : <String, dynamic>{},

		"allowAdd": false,
		"allowRemove": false
	};


	UserManagerComponent(this._stitch)
	{
		_userdb = _stitch.dbClient.db('user');
		getPermissions();
	}

	void getPermissions() async
	{
		await promiseToFuture(_userdb.collection('permission').find().asArray())
		.then((documents) 
		{
			List<String> plist = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertFromJS(documents[i]);
				Permission pr = Permission.fromJson(detail);
				plist.add(pr.title);
			}

			Map<String, dynamic> customfields = {
				'permissionName': plist,
			};

			options['types'] = customfields;

		}).catchError(_catchError);

		//print('permission gotten, ${plist.length}');
	}

	// dynamic getNavigatorDetail(int total, int page, int perPage)
	// {
	// 	int _total_pages = (total/perPage).toInt();
	// 	if(page > _total_pages) page = 1;

	// 	int from = 0;
	// 	if(perPage == 1) from = page-1;
	// 	else from = (perPage * page) - perPage;

	// 	if (page <= 1) from = 0;

	// 	Map result = {'from':from, 'to':perPage};
	// 	return result;
	// }

	// void getPage([int page=1]) async
	// {
	// 	await promiseToFuture(_userdb.collection('detail').count())
	// 	.then((count) {
	// 		total = count;
	// 	}).catchError(_catchError);


	// 	Map avigatorDetail = getNavigatorDetail(total, page, perPage);

	// 	dynamic pipline = js.jsify([
	// 		{"\$skip": avigatorDetail['from']},
	// 		{"\$limit": avigatorDetail['to']}
	// 	]);

	// 	await promiseToFuture(_userdb.collection('detail').aggregate(pipline).asArray())
	// 	.then((documents) 
	// 	{
	// 		list = [];	

	// 		for(int i=0; i < documents.length; i++)
	// 		{
	// 			dynamic detail = convertFromJS(documents[i]);
	// 			User user = User.fromJson(detail);
	// 			list.add(user);
	// 		}
	// 	});

	// 	print('users gotten, ${list.length}');
	// }

	void _catchError(error) => print(error);
}

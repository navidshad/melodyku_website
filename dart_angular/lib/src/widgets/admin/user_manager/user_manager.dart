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

	DbCollectionTableOptions options;

	UserManagerComponent(this._stitch)
	{
		options = DbCollectionTableOptions(
			disables: <String>['email', 'refId'],
			types 	: <String, dynamic>{},
			allowAdd: false,
			allowRemove: false
		);

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

			options.types = customfields;

		}).catchError(_catchError);

		//print('permission gotten, ${plist.length}');
	}

	void _catchError(error) => print(error);
}

import 'package:angular/angular.dart';
import 'dart:html';

import '../../../services/stitch_service.dart';

import '../../../class/user/permission.dart';

import '../dbCollection_table_editor/dbCollection_table_editor.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'user-manager',
	templateUrl: 'user_manager.html',
	styleUrls: ['user_manager.scss.css'],
	directives: [
		coreDirectives,
		DbCollectionTableEditorComponent
	]
)
class UserManagerComponent 
{
	StitchService _stitch;
	RemoteMongoDatabase _userdb;

	CollectionOptions options;

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
			List<DbField> permissions = [];

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertFromJS(documents[i]);
				Permission pr = Permission.fromJson(detail);
				DbField sub = DbField(pr.title, strvalue: pr.id.toString());
				permissions.add(sub);
			}

			options = CollectionOptions(
				title: 'Manage Users',
				database: 'user',
				collection: 'detail',
				dbFields: [
			        DbField('email'),
			        DbField('fullname'),
			        DbField('rfId', isDisable: true),
			        DbField('permissionId', subFields: permissions),
		      	]
			);

		}).catchError(_catchError);

		//print('permission gotten, ${plist.length}');
	}

	void _catchError(error) => print(error);
}

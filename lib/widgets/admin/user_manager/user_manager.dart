/// {@nodoc}
library userManager;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/mongo_stitch/mongo_stitch.dart';

@Component(
	selector: 'user-manager',
	templateUrl: 'user_manager.html',
	styleUrls: ['user_manager.css'],
	directives: [
		coreDirectives,
		DbCollectionTableEditorComponent
	]
)
class UserManagerComponent 
{
	StitchService _stitch;
	RemoteMongoDatabase _cms;

	CollectionOptions options;

	UserManagerComponent(this._stitch)
	{
		_cms = _stitch.dbClient.db('cms');
		getPermissions();
	}

	void getPermissions() async
	{
		await promiseToFuture(_cms.collection('permission').find().asArray())
		.then((documents) 
		{
			List<DbField> permissions = [];

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertToMap(documents[i], SystemSchema.permission);
				Permission pr = Permission.fromJson(detail);
				DbField sub = DbField(pr.title, strvalue: pr.id.toString());
				permissions.add(sub);
			}

			options = CollectionOptions(
				title: 'Manage Users',
				database: 'user',
				collection: 'detail',
				dbFields: SystemSchema.injectSubfields('permissionId', SystemSchema.userDetail, permissions),
				showHidenField: true,
			);

		}).catchError(_catchError);

		//print('permission gotten, ${plist.length}');
	}

	void _catchError(error) => print(error);
}

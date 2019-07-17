/// {@nodoc}
library userManager;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

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
	MongoDBService _mongodb;
	CollectionOptions options;

	UserManagerComponent(this._mongodb)
	{
		getPermissions();
	}

	void getPermissions() async
	{
    await _mongodb.find(database: 'cms', collection: 'permission')
      .then((documents) 
      {
        List<DbField> permissions = [];

        for(int i=0; i < documents.length; i++)
        {
          Map detail = validateFields(documents[i], SystemSchema.permission);
          DbField sub = DbField(detail['title'], strvalue: detail['id']);
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

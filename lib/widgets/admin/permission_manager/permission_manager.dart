/// {@nodoc}
library permisionManager;

import 'package:angular/angular.dart';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/core/core.dart';


@Component(
	selector: 'permission-manager',
	templateUrl: 'permission_manager.html',
	styleUrls: ['permission_manager.css'],
	directives: [
		coreDirectives,
		DbCollectionTableEditorComponent
	]
)
class PermissionManagerComponent 
{
	CollectionOptions options;

	PermissionManagerComponent()
	{
		options =  CollectionOptions(
      title: 'Manage Permissions',
      database: 'cms',
      collection: 'permission',
      allowQuery: false,
      allowAdd: true,
      allowUpdate: true,
      allowRemove: true,
      dbFields: SystemSchema.permission
		);
	}
}

import 'package:angular/angular.dart';

import '../dbCollection_table/dbCollection_table.dart';


@Component(
	selector: 'permission-manager',
	templateUrl: 'permission_manager.html',
	styleUrls: ['permission_manager.scss.css'],
	directives: [
		coreDirectives,
		DbCollectionTableComponent
	]
)
class PermissionManagerComponent 
{
	DbCollectionTableOptions options;

	PermissionManagerComponent()
	{
		options =  DbCollectionTableOptions(
			types : <String, dynamic>{
				'isDefault'			:'bool',
				'advanced_settings'	:'bool',
				'categorizing'		:'bool',
				'archive_manager'	:'bool',
				'customer_access'	:'bool',
				'quality_management':'bool',
				'user_manager'		:'bool',
			},
			allowQuery: false,
		);
	}
}

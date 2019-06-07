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
      dbFields: [
        DbField('title'),
        DbField('isDefault', customTitle: 'is default', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('advanced_settings', customTitle: 'advanced settings', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('categorizing', customTitle: 'categorizing', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('archive_manager', customTitle: 'archive manager', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('customer_access', customTitle: 'customer access', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('quality_management', customTitle: 'quality management', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('user_manager', customTitle: 'user manager', dataType: DataType.bool, fieldType: FieldType.checkbox),
      ]
		);
	}
}
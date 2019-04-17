import 'package:angular/angular.dart';

import '../dbCollection_table_editor/dbCollection_table_editor.dart';


@Component(
	selector: 'tariff-manager',
	templateUrl: 'tariff_manager.html',
	styleUrls: ['tariff_manager.scss.css'],
	directives: [
		coreDirectives,
		DbCollectionTableEditorComponent
	]
)
class TariffManagerComponent 
{
	CollectionOptions options;

	TariffManagerComponent()
	{
		options = CollectionOptions(
      title: 'Manage Tariffs',
      database: 'cms',
      collection: 'tariffs',
			allowQuery: false,
      dbFields: [
        DbField('title'),
        DbField('days', dataType: DataType.int),
        DbField('price', dataType: DataType.int),
        DbField('suggested', dataType: DataType.bool, fieldType: FieldType.checkbox),
        DbField('email'),
        DbField('refId'),
      ]
		);
	}
}

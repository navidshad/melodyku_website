/// {@nodoc}
library tariffManager;

import 'package:angular/angular.dart';

import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/core/core.dart';


@Component(
	selector: 'tariff-manager',
	templateUrl: 'tariff_manager.html',
	styleUrls: ['tariff_manager.css'],
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
	      	collection: 'tariff',
			allowQuery: false,
	      	dbFields: SystemSchema.tariff,
		);
	}
}
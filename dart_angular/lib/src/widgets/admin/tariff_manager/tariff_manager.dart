import 'package:angular/angular.dart';

import '../dbCollection_table/dbCollection_table.dart';


@Component(
	selector: 'tariff-manager',
	templateUrl: 'tariff_manager.html',
	styleUrls: ['tariff_manager.scss.css'],
	directives: [
		coreDirectives,
		DbCollectionTableComponent
	]
)
class TariffManagerComponent 
{
	CollectionOptions options;

	TariffManagerComponent()
	{
		options = CollectionOptions(
			fields	: <String>[ 'title', 'days', 'price', 'suggested' ],
			disables: <String>['email', 'refId'],
			types	: <String, dynamic>{ 'suggested':'bool' },
			allowQuery: false,
		);
	}
}

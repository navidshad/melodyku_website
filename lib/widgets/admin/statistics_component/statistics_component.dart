import 'package:angular/angular.dart';
import 'dart:async';

import 'package:melodyku/services/services.dart';

import 'piplines.dart';

@Component(
	selector: 'admin-staistics',
	templateUrl: 'satistics_component.html',
	styleUrls: ['satistics_component.css'],
	directives: [
		coreDirectives,
	]
)
class AdminStatisticsComponent
{
	MongoDBService _mongodb;

	List<AggregatePiplines> statisticPrplines = [];
	Map<String, int> todayDataTable = {};
	Map<String, int> totalDataTable = {};
	Map<String, int> categoriesDataTable = {};

	AdminStatisticsComponent(this._mongodb)
	{
		prepare();
	}

	void prepare()
	{
		gestatistic(getTodayPiplines()).then((r) => todayDataTable = r);
		gestatistic(getTotalPiplines()).then((r) => totalDataTable = r);
		gestatistic(getCategoriesPiplines()).then((r) => categoriesDataTable = r);
	}

	Future<Map<String, int>> gestatistic(List<AggregatePiplines> statisticPrplines) async
	{
		List<Future> futures = [];
		Map<String, int> dataTable = {};
		//List<AggregatePiplines> statisticPrplines = getTodayPiplines();

		statisticPrplines.forEach((ap)
		{
			Future f = _mongodb.aggregate(
				isLive		: false, 
				database	: ap.database, 
				collection	: ap.collection, 
				piplines	: ap.piplines,
				bodyKey		: 'piplines', 
				types		: ap.types
			);
			futures.add(f);
		});

		List<dynamic> results = await Future.wait(futures).catchError(print);

		if(results == null) return {};

		for(int i=0; i < results.length; i++)
		{
			String title = statisticPrplines[i].title;
			int count = 0;
			
			if(results[i].length > 0)
				count = results[i][0]['count'];

			dataTable[title] = count;
		}

		return dataTable;
	}
}
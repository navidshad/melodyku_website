/// {@nodoc}
library aggregate;

import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/mongo_stitch/mongo_stitch.dart';

class Aggregate 
{
	RemoteMongoCollection collection;
	List<Map> pipline;
	bool hasMore = false;
	int _totalItems = 0;
	int perPage = 20;
	int _page = 0;

	Aggregate({this.collection, this.pipline=const[], this.perPage=20});

	void initialize() async
	{
		// get count ============================
		List<Map> countPipeline = [
				{ "\$count": "count" }
			];

		countPipeline.insertAll(0, pipline);

		_totalItems = await promiseToFuture(
				collection.aggregate(js.jsify(countPipeline)).first()
			).then((result) {
				int value = result != null ? js.getProperty(result, 'count') : 0;
				return value;
			});
	}

	Future<List<dynamic>> loadNextPage() async
	{
		_page += 1;

		Map navigatorDetail = getNavigatorDetail(total: _totalItems, page: _page, perPage: perPage);
		print('=== loadNextPage $navigatorDetail | page $_page');

		List<Map> nextPipeline = [
			{
				'\$skip' : navigatorDetail['from']
			},

			{
				'\$limit': navigatorDetail['to']
			}
		];

		nextPipeline.insertAll(0, pipline);

		List<dynamic> docs = await promiseToFuture(
				collection.aggregate(js.jsify(nextPipeline)).asArray()
			).catchError(_handleError);


		if(_page < navigatorDetail['pages']) 
			hasMore = true;
		else hasMore = false;

		return docs;
	}

	Exception _handleError(dynamic e) {
	    print(e); // for demo purposes only
	    return Exception('Aggregate error; cause: $e');
	}
}
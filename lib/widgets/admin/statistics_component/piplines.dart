import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

List<AggregatePiplines> getTodayPiplines()
{
	List<AggregatePiplines> getStatisticPiplines = 
	[
		AggregatePiplines(
			title		: 'Users',
			database	: 'cms',
			collection	: 'auth',
			piplines	: [
				{
					'\$match': {
						'createdAt': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() }
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.createdAt.\$gte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: '3 Days left subscribers',
			database	: 'user',
			collection	: 'subscription',
			piplines	: [
				{
					'\$match': {
						'expiresIn': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
					}
				},
				{

					'\$match': {
						'expiresIn': { '\$lte'	: getDate(DateTime.now().add(Duration(days:3)).toUtc()).toIso8601String() },
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.expiresIn.\$gte'),
				TypeCaster('Date', '1.\$match.expiresIn.\$lte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Paid Factors',
			database	: 'user',
			collection	: 'factor',
			piplines	: [
				{
					'\$match': {
						'createdAt': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
						'amount': { '\$gte'	: 1 },
						'isPaid': true,
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.createdAt.\$gte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Uploads',
			database	: 'media',
			collection	: 'song',
			piplines	: [
				{
					'\$match': {
						'createdAt': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.createdAt.\$gte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Likes',
			database	: 'user',
			collection	: 'song_favorite',
			piplines	: [
				{
					'\$match': {
						'date': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.date.\$gte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Full Played',
			database	: 'user',
			collection	: 'song_history',
			piplines	: [
				{
					'\$match': {
						'date': { '\$gte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.date.\$gte')
			],
			addCountAsLastPipline : true
		),
	];	

	return getStatisticPiplines;
}

List<AggregatePiplines> getTotalPiplines()
{
	List<AggregatePiplines> getStatisticPiplines = 
	[
		AggregatePiplines(
			title		: 'Users',
			database	: 'cms',
			collection	: 'auth',
			piplines	: [],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Unsubscribed Users',
			database	: 'user',
			collection	: 'subscription',
			piplines	: [
				{
					'\$match': {
						'expiresIn': { '\$lte'	: getDate(DateTime.now().toUtc()).toIso8601String() },
					}
				}
			],
			types: [
				TypeCaster('Date', '0.\$match.expiresIn.\$lte')
			],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Songs',
			database	: 'media',
			collection	: 'song',
			piplines	: [],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Albums',
			database	: 'media',
			collection	: 'album',
			piplines	: [],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Artists',
			database	: 'media',
			collection	: 'artist',
			piplines	: [],
			addCountAsLastPipline : true
		),

		AggregatePiplines(
			title		: 'Categories',
			database	: 'media',
			collection	: 'category',
			piplines	: [],
			addCountAsLastPipline : true
		),
	];	

	return getStatisticPiplines;
}

List<AggregatePiplines> getCategoriesPiplines()
{
	List<AggregatePiplines> getStatisticPiplines = [];
	List<DbField> cats = Injector.get<CategoryService>().getCategories();
	
	cats.forEach((cat)
	{
		getStatisticPiplines.add(AggregatePiplines(
			title		: '${cat.title.toUpperCase()} Songs',
			database	: 'media',
			collection	: 'song',
			piplines	: [
				{
					'\$match': { 'categories': cat.strvalue }
				}
			],
			addCountAsLastPipline : true
		));

		getStatisticPiplines.add(AggregatePiplines(
			title		: '${cat.title.toUpperCase()} Albums',
			database	: 'media',
			collection	: 'album',
			piplines	: [
				{
					'\$match': { 'categories': cat.strvalue }
				}
			],
			addCountAsLastPipline : true
		));

		getStatisticPiplines.add(AggregatePiplines(
			title		: '${cat.title.toUpperCase()} Artists',
			database	: 'media',
			collection	: 'artist',
			piplines	: [
				{
					'\$match': { 'categories': cat.strvalue }
				}
			],
			addCountAsLastPipline : true
		));
	});

	return getStatisticPiplines;
}

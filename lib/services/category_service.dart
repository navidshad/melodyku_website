import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/mongo_stitch/mongo_stitch.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class CategoryService
{
	//StitchService _stitchService;
	StitchCatcherService _stitchCatcher;
	List<Map> _groups = [];
	List<Map> _categories = [];

	CategoryService(this._stitchCatcher)
	{
		getGroupsFromDb();
		getCategoriesFromDb();
	}

	void getGroupsFromDb() async
	{
		// RemoteMongoCollection coll = await _stitchService
		// 	.getCollectionAsync(db: 'media', collection: 'category_group');
			
		// Future request = promiseToFuture(coll.find().asArray());

		// Injector.get<StitchService>().requestByQueue(request)
		// .then((docs) 
		// {
		// 	for(dynamic doc in docs)
		// 	{
		// 		Map converted = convertToMap(doc, SystemSchema.category_group);
		// 		_groups.add(converted);
		// 	}
		// });

		_stitchCatcher.getAll(collection: 'category_group')
			.then((docs) 
			{
				for(dynamic doc in docs)
				{
					Map converted = convertToMap(js.jsify(doc), SystemSchema.category_group);
					_groups.add(converted);
				}
			});
	}

	void getCategoriesFromDb() async
	{
		// RemoteMongoCollection coll = await _stitchService
		// 	.getCollectionAsync(db: 'media', collection: 'category');
			
		// Future request = promiseToFuture(coll.find().asArray());

		// Injector.get<StitchService>().requestByQueue(request)
		// .then((docs) 
		// {
		// 	for(dynamic doc in docs)
		// 	{
		// 		Map converted = convertToMap(doc, SystemSchema.category);
		// 		_categories.add(converted);
		// 	}
		// });

		_stitchCatcher.getAll(collection: 'category')
			.then((docs) 
			{
				for(dynamic doc in docs)
				{
					Map converted = convertToMap(js.jsify(doc), SystemSchema.category);
					_categories.add(converted);
				}
			});
	}

	List<DbField> _getCategoriesByGroup(groupId)
	{
		List<DbField> list = [];

		_categories.forEach((category) 
		{
			if(category['groupId'] != groupId) return;

			DbField field = DbField(category['title'], 
					strvalue: category['_id'].toString());

			list.add(field);
		});

		return list;
	}

	List<DbField> getGroups() 
	{
		List<DbField> list = [];

		_groups.forEach((group) 
		{
			DbField field = DbField(group['title'], 
					strvalue: group['_id'].toString());

			// subfields
			field.subFields = _getCategoriesByGroup(group['_id'].toString());

			list.add(field);
		});

		return list;
	}
}
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class CategoryService
{
	//StitchService _stitchService;
	MongoDBService _mongodb;
	List<Map> _groups = [];
	List<Map> _categories = [];

	CategoryService(this._mongodb)
	{
		// they will be called from app shell
		//getGroupsFromDb();
		//getCategoriesFromDb();
	}

	Future<void> getGroupsFromDb() async
	{
		return _mongodb.find(database: 'media', collection: 'category_group')
			.then((docs) 
			{
				for(dynamic doc in docs)
				{
					Map converted = validateFields(doc, SystemSchema.category_group);
					_groups.add(converted);
				}
			});
	}

	Future<void> getCategoriesFromDb() async
	{
		return _mongodb.find(database: 'media', collection: 'category')
			.then((docs) 
			{
				for(dynamic doc in docs)
				{
					Map converted = validateFields(doc, SystemSchema.category);
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

	Map getCategoryById(String id)
	{
		Map category;

		int index = _categories.indexWhere((Map cat) => cat['_id'] == id ? true : false);
		if(index >= 0) category = _categories[index];

		return category;
	}
}
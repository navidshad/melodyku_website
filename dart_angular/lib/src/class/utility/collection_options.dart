import 'package:angular_router/angular_router.dart';

import 'package:melodyku/mongo_stitch/field.dart';
export 'package:melodyku/mongo_stitch/field.dart';

class LinkButton 
{
	String title;
	RouteDefinition route;
	List<String> parameters;

	LinkButton({this.title, this.route, this.parameters});

	String toUrl(dynamic doc)
	{

		Map<String, String> params = {};

		if(parameters != null)
		{
			parameters.forEach((key) {
				params[key] = doc[key].toString();
			});
		}
		
		return '#'+route.toUrl(params);
	}
}

class SubField {
	String title;
	String key;
	dynamic value;

	SubField({this.title, this.key, this.value});
}

class CollectionOptions 
{
	String title;
	String database;
	String collection;

	List<LinkButton> linkButtons;
	Map<String, dynamic> query;

	List<DbField> dbFields;

	bool createNew;
	bool allowAdd = true;
	bool allowUpdate = true;
	bool allowRemove = true;
	bool allowQuery = true;
	bool hasNavigator = true;
	bool hasCover = false;

	dynamic id;
	dynamic document;

	CollectionOptions({
		this.title, 			this.database,		this.collection, 	this.id, 			this.document,
		this.linkButtons, 		this.query,			this.dbFields,
		this.createNew	 = false,
		this.allowAdd 	 = true, 		 	 	
		this.allowUpdate = true,
		this.allowRemove = true,
		this.allowQuery  = true, 
		this.hasNavigator=true, 
		this.hasCover 	 = false,	
	});
}
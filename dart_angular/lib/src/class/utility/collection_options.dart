import 'package:angular_router/angular_router.dart';

import 'package:melodyku/mongo_stitch/field.dart';
export 'package:melodyku/mongo_stitch/field.dart';

class LinkButton {
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

	List<String> fields;
	Map<String, dynamic> types;
	List<String> disables;
	List<LinkButton> linkButtons;
	Map<String, dynamic> query;

	List<DbField> dbFields;

	bool allowAdd = true;
	bool allowUpdate = true;
	bool allowRemove = true;
	bool allowQuery = true;
	bool hasNavigator = true;
	bool hasCover = false;	

	List<String> stringArrays;
	List<String> stringObjects;

	String id;
	dynamic document;

	CollectionOptions({
		this.title, 		this.database,		this.collection, 	this.id, 			this.document,
		this.fields, 		this.types, 		this.disables, 		this.linkButtons, 	this.query,
		this.allowAdd, 		this.allowUpdate, 	this.allowRemove, 	this.allowQuery, 
		this.hasNavigator, 	this.hasCover,
		this.stringArrays, 	this.stringObjects,
		this.dbFields,
	});
}
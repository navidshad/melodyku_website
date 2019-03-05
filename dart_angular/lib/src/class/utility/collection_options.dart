import 'package:angular_router/angular_router.dart';

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
	String collection;

	List<String> fields;
	Map<String, dynamic> types;
	List<String> disables;
	List<LinkButton> linkButtons;
	Map<String, dynamic> query;

	bool allowAdd;
	bool allowUpdate;
	bool allowRemove;
	bool allowQuery;
	bool hasNavigator;
	bool hasCover;	

	List<String> stringArrays;
	List<String> stringObjects;

	String id;
	dynamic document;

	CollectionOptions({
		this.title, 		this.collection, 	this.id, 			this.document,
		this.fields, 		this.types, 		this.disables, 		this.linkButtons, 	this.query,
		this.allowAdd, 		this.allowUpdate, 	this.allowRemove, 	this.allowQuery, 
		this.hasNavigator, 	this.hasCover,
		this.stringArrays, 	this.stringObjects
	});
}
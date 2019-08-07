/// {@nodoc}
library collectionOptions;

import 'package:angular_router/angular_router.dart';

import 'package:melodyku/mongodb/field.dart';

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

class ActionButton
{
	String title;
	Function onEvent;

	ActionButton({this.title, this.onEvent});

	void onClick(Map doc){
		if(onEvent != null) onEvent(doc);
	}
}

class CollectionOptions 
{
	String title;
	String database;
	String collection;

	List<LinkButton> linkButtons;
	List<ActionButton> actionButtons;
	Map<String, dynamic> query;
	Map<String, dynamic> sort;
	Map<String, dynamic> addOnCreate;

	List<DbField> dbFields;

	bool createNew;
	bool showHidenField;
	bool allowAdd = true;
	bool allowUpdate = true;
	bool allowRemove = true;
	bool allowQuery = true;
	bool hasNavigator = true;
	bool hasCover = false;

	dynamic id;
	dynamic document;

	CollectionOptions({
		this.title, 			
		this.database,		
		this.collection, 	
		this.id, 			
		this.document,
		this.linkButtons=const [],		
		this.actionButtons= const [],
		this.query=const{},			
		this.addOnCreate=const{},
		this.sort,			
		this.dbFields,
		this.createNew	 = false,
		this.showHidenField	 = false,
		this.allowAdd 	 = true, 		 	 	
		this.allowUpdate = true,
		this.allowRemove = true,
		this.allowQuery  = true, 
		this.hasNavigator=true, 
		this.hasCover 	 = false,	
	});

	List<DbField> getValidFields()
	{
		List<DbField> list = [];
		dbFields.forEach((DbField f) { 
			if(!f.isHide || showHidenField) list.add(f); 
		});
		return list;
	}
}
/// {@nodoc}
library collectionOptions;

import 'dart:async';
import 'package:angular_router/angular_router.dart';

import 'package:melodyku/mongodb/mongodb.dart';
import 'package:melodyku/core/core.dart';

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
	Function(Map doc, ButtonOptions options) onEvent;
	ButtonOptions options;

	ActionButton({this.title, this.onEvent})
	{
		options = ButtonOptions(
			lable: title, 
			type: ButtonType.sl_x,
			callbackWithArg: _onClick);
	}

	void _onClick(dynamic doc, ButtonOptions op)
	{
		if(onEvent != null) onEvent(doc as Map, op);
	}
}

class Column{
  String title;
  List dataArray;

  Column({this.title, this.dataArray=const[]});

  dynamic getById(String id)
  {
    dynamic value;
    int index = dataArray.indexWhere((el) => el['_id'] == id);

    if(index >= 0) value = dataArray[index][title];
    return value;
  }
}

class CollectionOptions 
{
	StreamController _clearControler = StreamController();
	StreamController _getControler = StreamController();
	StreamController<List<Map>> onLoadPageControler = StreamController<List<Map>>();

	
  Stream get clearStream => _clearControler.stream;
  Stream get getStream => _getControler.stream;

	String title;
	String database;
	String collection;

	List<LinkButton> linkButtons;
	List<ActionButton> actionButtons;
  List<Column> aditionalColumns;

	List<Map> piplines = [];
  Map<String, dynamic> query;
	Map<String, dynamic> sort;
	Map<String, dynamic> addOnCreate;

	List<DbField> dbFields;
  List<TypeCaster> types;

	bool createNew;
	bool showHidenField;
	bool allowAdd = true;
	bool allowUpdate = true;
	bool allowRemove = true;
	bool allowQuery = true;
	bool hasNavigator = true;
	bool hasCover = false;
	bool autoGet = true;

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
    this.aditionalColumns= const [],
		this.piplines=const [],
    this.query=const{},			
		this.addOnCreate=const{},
		this.sort,			
		this.dbFields=const[],
		this.createNew	 = false,
		this.showHidenField	 = false,
		this.allowAdd 	 = true, 		 	 	
		this.allowUpdate = true,
		this.allowRemove = true,
		this.allowQuery  = true, 
		this.hasNavigator=true, 
		this.hasCover 	 = false,
		this.autoGet	 =true,
		this.types,
	});

	List<DbField> getValidFields()
	{
		List<DbField> list = [];
		dbFields.forEach((DbField f) { 
			if(!f.isHide || showHidenField) list.add(f); 
		});
		return list;
	}

	ActionButton getCloneButton(ActionButton ab)
	{
		ActionButton newBtn = ActionButton(title: ab.title, onEvent: ab.onEvent);
		return newBtn;
	}

	void clear() => _clearControler.add(true);
	void getData() => _getControler.add(true);
}
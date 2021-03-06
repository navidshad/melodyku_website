/// {@nodoc}
library dbcollectionItemEditor;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:async';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'db-collection-item-editor',
	templateUrl: 'dbCollection_item_editor.html',
	styleUrls: ['dbCollection_item_editor.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
		CoverItemEditor,
		ObjectField,
	],
	exports: [
		FieldType,
	]
)
class DbCollectionItemEditorComponent
{
	final eventController = StreamController<bool>();
  	Modal modal;

  	MongoDBService _mongodb;

	DbCollectionItemEditorComponent(this._mongodb);

	Map editable;
	CollectionOptions op;

	bool viewMode = true;
	bool isUpdating = false;
	bool createNew= false;

	String error;
	
	@Input()
	void set options(CollectionOptions options)
	{
		//print('=== begin to get options');
		op = options;

		if(options.document != null)	setNewEditable(options.document);
		else if(options.id != null) 	getItem();

		if(op.createNew) changeMode(false);
		print('=== end to get options');
	}

	@Output()
	Stream get onChanged => eventController.stream;

	void changeMode([bool key]) => viewMode = key ?? !viewMode;

	void getItem() async
	{
		//await Future.delayed(Duration(seconds:1));

		//print('getting item, ${op.id.toString()}');

		// create update query
		Map query = {'_id': op.id};

		if(op.query != null)
			query.addAll(op.query);

		// get by aggregate
	await _mongodb.findOne(isLive:true, database: op.database, collection: op.collection, query: query)
      .then((document) 
      {
        // List<String> keies = getKeies(document, removes: ['_id']);
        // if(fields.length == 0) fields = keies;
        //print('gotten item, $document');
        setNewEditable(document);
        
      }).catchError(_catchError);

		//print('item gotten, ${editable}');
	}

	void setNewEditable(dynamic doc) 
  	{
		editable = validateFields(doc, op.dbFields);
		op.id = editable['_id'];
	}

	void normalize()
	{
		editable = validateFields(editable, op.dbFields);
	}

	void createItem() async 
	{
		error = '';
		isUpdating = true;

		editable.addAll(op.addOnCreate);
		normalize();

		await _mongodb.insertOne(isLive:true, database: op.database, collection: op.collection, doc: editable)
		.then((d)
		{
			getItem();
			changeMode(false);
			op.createNew = false;

			eventController.add(true);
		})
		.catchError(_catchError);

		isUpdating = false;
	}

	void updateItem() async
	{
		error = '';
		isUpdating = true;

		// create update query
		Map query = {'_id': editable['_id']};

		if(op.query != null)
			query.addAll(op.query);

		// remove id
		editable.remove('_id');
		normalize();

		//print('updating $editable');
		
		// create update option
		Map update = { '\$set': editable };

		await _mongodb.updateOne(isLive:true, database: op.database, collection: op.collection, 
		query: query, update: update)
		.then((d)
		{
			getItem();
			changeMode(false);
			eventController.add(true);
		})
		.catchError(_catchError);

		isUpdating = false;
		viewMode = true;
	}

	void _catchError(err){
		print('== DbCollectionItemEditorComponent error $err');
		error = err.toString();
		eventController.add(false);
	}
}
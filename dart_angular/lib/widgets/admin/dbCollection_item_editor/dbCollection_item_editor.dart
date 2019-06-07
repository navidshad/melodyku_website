/// {@nodoc}
library dbcollectionItemEditor;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:async';

import 'package:js/js_util.dart' as js;

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/mongo_stitch/mongo_stitch.dart';

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
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	DbCollectionItemEditorComponent(this._stitch, this._modalService)
	{
		print('DbCollectionItemEditorComponent constructor');
	}

	Map editable;
	CollectionOptions op;

	bool viewMode = true;
	bool isUpdating = false;
	bool createNew= false;
	
	@Input()
	void set options(CollectionOptions options)
	{
		print('=== begin to get options');
		op = options;

		if(options.document != null)	setNewEditable(options.document);
		else if(options.id != null) 	getItem();

		if(op.createNew) changeMode(false);

		_collection = _stitch.dbClient.db(op.database).collection(op.collection);
		print('=== end to get options');
	}

	@Output()
	Stream get onChanged => eventController.stream;

	void changeMode([bool key]) => viewMode = key ?? !viewMode;

	void getItem() async
	{
		//await Future.delayed(Duration(seconds:1));

		print('getting item, ${op.id.toString()}');

		// get by aggregate
		await promiseToFuture(_stitch.appClient.callFunction('getById', [op.database, op.collection, op.id.toString()]))
		.then((document) 
		{
			// List<String> keies = getKeies(document, removes: ['_id']);
			// if(fields.length == 0) fields = keies;
			//print('gotten item, $document');
			setNewEditable(document);
			
		}).catchError(_catchError);

		//print('item gotten, ${editable}');
	}

	void setNewEditable(dynamic doc) {
		log(doc);
		editable = convertToMap(doc, op.dbFields);
		op.id = editable['_id'];
	}

	void createItem() async 
	{
		isUpdating = true;

		dynamic newItem = js.jsify(editable);

		await promiseToFuture(_collection.insertOne(newItem))
		.then((d)
		{
			log(d);
			getItem();
			changeMode(false);

			eventController.add(true);
		})
		.catchError(_catchError);

		isUpdating = false;
		op.createNew = false;
	}

	void updateItem() async
	{
		isUpdating = true;

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		// remove id
		editable.remove('_id');

		print('updating $editable');
		
		// create update option
		dynamic update = js.jsify({ '\$set': editable });

		await promiseToFuture(_collection.updateOne(query, update))
		.then((d)
		{
			log(d);
			getItem();
			changeMode(false);
			eventController.add(true);
		})
		.catchError(_catchError);

		isUpdating = false;
		viewMode = true;
	}

	void removeItem() async
	{
		modal.doWaiting(true);

		//print('deleting ${editable['_id']}');

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		await promiseToFuture(_collection.deleteOne(query))
		.then((d)
		{
			log(d);
			getItem();
			eventController.add(true);
		})
		.catchError(_catchError);
	}

	void _catchError(error){
		print(error.toString());
		eventController.add(false);
	}
}
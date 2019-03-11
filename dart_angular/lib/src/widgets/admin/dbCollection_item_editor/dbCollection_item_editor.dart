import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:convert';

import 'package:js/js_util.dart' as js;

import '../../../services/stitch_service.dart';
import '../../../services/modal_service.dart';

import '../../../class/modal/modal.dart';

import '../../../class/utility/collection_options.dart';
export '../../../class/utility/collection_options.dart';

import '../../../directives/ElementExtractorDirective.dart';

import '../cover_item_editor/cover_item_editor.dart';
import '../db_form/one_layered_object/one_layered_object.dart';
import '../db_form/select_item/select_item.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'db-collection-item-editor',
	templateUrl: 'dbCollection_item_editor.html',
	styleUrls: ['dbCollection_item_editor.scss.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
		CoverItemEditor,
		OneLayeredObject,
		SelectItem,
	],
	exports: [
		fieldType,
	]
)
class dbCollection_item_editor
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	dbCollection_item_editor(this._stitch, this._modalService)
	{
		
	}

	List<DbField> fields = [];

	String 	title;
	String 	database;
	String 	collection;
	String 	id;

	dynamic editable;

	bool editeMode = false;
	bool isUpdating = false;
	bool hasCover = true;
	
	@Input()
	void set options(CollectionOptions options)
	{
		if(options.title != null) 	 	title = options.title;
		if(options.database != null) 	database = options.database;
		if(options.collection != null) 	collection = options.collection;
		if(options.id != null) 			id = options.id;

		if(options.dbFields != null)	fields = options.dbFields;

		if(options.hasCover != null)	hasCover = options.hasCover;


		if(options.document != null)	setNewEditable(options.document);
		if(editable == null) getItem();

		_collection = _stitch.dbClient.db(database).collection(collection);
	}

	void changeMode([bool key]) => editeMode = key ?? !editeMode;


	void addValueToObjectFiled(field, key, value)
	{
		String runtimeType = editable[field].runtimeType.toString();
		//print(editable[field].runtimeType);

		if(editable[field] == null || runtimeType != 'LinkedMap<dynamic, dynamic>') 
			editable[field] = {};

		editable[field][key] = value;

		//print('addValueToObjectFiled $editable');
	}

	String getValueOfObjectField(field, key)
	{
		String value = '';

		try{
			value = editable[field][key];
		}
		catch(e){}

		return value;
	}

	void getItem({int page, int navigate}) async
	{
		//await Future.delayed(Duration(seconds:1));

		// get by aggregate
		await promiseToFuture(_stitch.appClient.callFunction('getById', ['media', collection, id]))
		.then((document) 
		{
			// List<String> keies = getKeies(document, removes: ['_id']);
			// if(fields.length == 0) fields = keies;

			setNewEditable(document);
			
		}).catchError(_catchError);

		//print('item gotten, ${editable['_id']}');
	}

	void setNewEditable(dynamic doc) {
		//editable = convertFromJS(doc, stringArrays: stringArrays, stringObjects: stringObjects);
		editable = convertFromJS(doc);
		id = editable['_id'].toString();

		//print('editable $editable');
	}

	void updateItem() async
	{
		isUpdating = true;

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		// remove id memebr
		editable = deleteDynamicMembers(editable, ['_id']);

		// normaliz
		editable = normalize(editable);

		//print('updating $editable');

		// create update option
		dynamic update = js.jsify({ '\$set': editable });

		await promiseToFuture(_collection.updateOne(query, update))
		.then((d){
			//print(convertFromJS(d));
			getItem();
			changeMode(false);
		})
		.catchError(_catchError);

		isUpdating = false;
	}

	void removeItem() async
	{
		modal.doWaiting(true);

		//print('deleting ${editable['_id']}');

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		await promiseToFuture(_collection.deleteOne(query))
		.then((d){
			print(convertFromJS(d));
			getItem();
		})
		.catchError(_catchError);
	}

	void _catchError(error){
		print(error.toString());
	}
}
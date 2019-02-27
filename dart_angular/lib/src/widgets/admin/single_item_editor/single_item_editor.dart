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

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'single-item-editor',
	templateUrl: 'single_item_editor.html',
	styleUrls: ['single_item_editor.scss.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
		CoverItemEditor,
	]
)
class SingleItemEditor
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	SingleItemEditor(this._stitch, this._modalService)
	{
		
	}

	List<String> disables = [];
	List<String> fields = [];
	Map<String, dynamic> customFieldTypes = {};
	List<String> stringArrays = [];
	List<String> stringObjects = [];

	String 	title;
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
		if(options.collection != null) 	collection = options.collection;
		if(options.id != null) 			id = options.id;

		if(options.fields != null) 	 	fields = options.fields;
		if(options.types != null) 	 	customFieldTypes = options.types;

		if(options.hasCover != null)	hasCover = options.hasCover;

		if(options.stringArrays != null) stringArrays = options.stringArrays;
		if(options.stringObjects != null) stringObjects = options.stringObjects;

		getItem();
		_collection = _stitch.dbClient.db('media').collection(collection);
	}

	void changeMode() => editeMode = !editeMode;

	bool getActiveStatus(String field)
	{
		bool isActive = true;

		if(disables != null) disables.forEach((item) {
			if(field == item) isActive = false;
		});

		return isActive;
	}

	String getFiledType(String field)
	{
		String type = 'String';

		if(customFieldTypes.containsKey(field))
		{
			// detect list
			if(customFieldTypes[field].runtimeType.toString() == 'List<String>')
				type = customFieldTypes[field].runtimeType.toString();

			else if(customFieldTypes[field].runtimeType.toString() == 'IdentityMap<String, SingleItemObjectProperty>')
				type = customFieldTypes[field].runtimeType.toString();

			// use vlue of the member as type
			else type = customFieldTypes[field]; 
		}

		return type;
	}

	void addValueToObjectFiled(field, key, value)
	{
		String runtimeType = editable[field].runtimeType.toString();
		print(editable[field].runtimeType);

		if(editable[field] == null || runtimeType != 'LinkedMap<dynamic, dynamic>') 
			editable[field] = {};

		editable[field][key] = value;

		print('addValueToObjectFiled $editable');
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
			List<String> keies = getKeies(document, removes: ['_id']);
			if(fields.length == 0) fields = keies;

			editable = convertFromJS(document, stringArrays: stringArrays, stringObjects: stringObjects);
			
		}).catchError(_catchError);

		print('item gotten, ${editable['_id']}');
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

		print('updating $editable');

		// create update option
		dynamic update = js.jsify({ '\$set': editable });

		await promiseToFuture(_collection.updateOne(query, update))
		.then((d){
			print(convertFromJS(d));
			getItem();
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
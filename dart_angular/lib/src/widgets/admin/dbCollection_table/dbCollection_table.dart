import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:convert';

import 'package:js/js_util.dart' as js;

import '../../../services/stitch_service.dart';
import '../../../services/modal_service.dart';

import '../../../class/modal/modal.dart';

import '../../../directives/ElementExtractorDirective.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'db-collection-table',
	templateUrl: 'dbCollection_table.html',
	styleUrls: ['dbCollection_table.scss.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
	]
)
class DbCollectionTableComponent
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	List<String> fields = [];
	Map<String, dynamic> customFieldTypes= {};

	List<dynamic> list = [];
	dynamic editable;

	String modalName = '';
	String formType;

	bool couldAdd = true;
	bool couldUpdate = true;
	bool couldRemove = true;

	@Input() String title;
	@Input() String dataBase;
	@Input() String collection;

	@Input() List<String> disables;
	@Input() void customFields(List<String> value) => fields = value;

	@Input()
	void set addButton(bool value) => couldAdd = value;
	@Input()
	void set removeButton(bool value) => couldRemove = value;
	@Input()
	void set updateButton(bool value) => couldUpdate = value;

	DbCollectionTableComponent(this._stitch, this._modalService)
	{
		getData();

		print('object type is ' + {}.runtimeType.toString());
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modalName = '${title}_modal';

		modal = Modal(el);
		_modalService.register(modalName, modal);
	}

	String getFiledType(String field)
	{
		String type = 'String';

		if(customFieldTypes.containsKey(field))
		{
			// detect list
			if(customFieldTypes[field].runtimeType == 'List<String>')
				type = customFieldTypes[field].runtimeType;
			// use vlue of the member as type
			else type = customFieldTypes[field]; 
		}

		return type;
	}

	void showForm(String type, [dynamic selected])
	{
		editable = selected ?? {};
		formType = type;

		_modalService.show(modalName);
	}

	void getData() async
	{
		print('begin to get data');

		await Future.delayed(Duration(seconds:1));

		// get collection
		if(_collection == null)
			_collection = _stitch.dbClient.db(dataBase).collection(collection);

		// get data
		await promiseToFuture(_collection.find().asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic document = documents[i];

				print('document $document');

				// crate fields dont exists
				if(fields.length == 0) fields = getKeies(document, removes: ['_id']);

				// add item to list for presenting
				dynamic item = convertFromJS(document);
				list.add(item);
			}
		}).catchError(printError);

		print('items gotten, ${list.length}');
	}

	void addNewItem() async
	{
		// normaliz
		editable = normalize(editable);

		dynamic newItem = js.jsify(editable);

		await promiseToFuture(_collection.insertOne(newItem))
		.then((document) {
			getData();
			modal.close();
		})
		.catchError(printError);		
	}

	void updateItem() async
	{
		modal.doWaiting(true);

		print('updating ${editable['_id']}');

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		// normaliz
		editable = normalize(editable);

		// remove id memebr
		editable = deleteDynamicMembers(editable, ['_id']);

		// create update option
		dynamic update = js.jsify({ '\$set': editable });

		await promiseToFuture(_collection.updateOne(query, update))
		.then((d){
			print(convertFromJS(d));
			getData();
			modal.close();
		})
		.catchError(printError);
	}

	void removeItem() async
	{
		modal.doWaiting(true);

		print('deleting ${editable['_id']}');

		// create update query
		dynamic query = js.jsify({'_id': editable['_id']});

		await promiseToFuture(_collection.deleteOne(query))
		.then((d){
			print(convertFromJS(d));
			getData();
			modal.close();
		})
		.catchError(printError);
	}

	dynamic normalize(dynamic object)
	{
		dynamic normalized = {};

		getKeies(js.jsify(object)).forEach((key) 
		{
			print('key $key');

			// _id
			if(key == '_id') normalized[key] = object[key];

			// normalizing field and specify the type of it
			// bool
			else if(object[key] == 'true' && object[key] == 'false')
				normalized[key] = bool.fromEnvironment(object[key]);
			// int
			else if (int.tryParse(object[key].toString()) != null)
				normalized[key] = int.tryParse(object[key]);
			// double
			else if (double.tryParse(object[key].toString()) != null)
				normalized[key] = double.tryParse(object[key]);

			// json form
			else {
				try{
					normalized[key] = json.decode(object[key]);
				}
				catch(e){
					normalized[key] = object[key];
				}
			}
		});

		return normalized;
	}	

	void printError(error)
	{
		print(error);
		modal.addMessage(error, color: 'red');
		modal.showMessage();
		modal.doWaiting(false);
	}
}
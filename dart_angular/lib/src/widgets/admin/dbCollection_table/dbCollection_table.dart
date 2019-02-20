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
	Map<String, dynamic> customFieldTypes = {};

	List<dynamic> list = [];
	dynamic editable;
	dynamic searchQuery;
	dynamic _query = {};

	String modalName = '';
	String formType;

	bool couldAdd = true;
	bool couldUpdate = true;
	bool couldRemove = true;
	bool couldQuery = true;
	bool hasNavigator = true;

	List<String> disables = [];

	int perPage = 10;
	int total = 0;
	int total_pages = 0;
	int current_page = 1;

	@Input() String title;
	@Input() String dataBase;
	@Input() String collection;

	@Input()
	void set options(Map<String, dynamic> options)
	{
		if(options.containsKey('fields')) 	fields = options['fields'];
		if(options.containsKey('types')) 	customFieldTypes = options['types'];
		if(options.containsKey('disables')) disables = options['disables'];
		
		if(options.containsKey('allowAdd')) 	couldAdd = options['allowAdd'];
		if(options.containsKey('allowUpdate')) 	couldUpdate = options['allowUpdate'];
		if(options.containsKey('allowRemove')) 	couldRemove = options['allowRemove'];
		if(options.containsKey('allowQuery')) 	couldQuery = options['allowQuery'];
		if(options.containsKey('hasNavigator')) hasNavigator = options['hasNavigator'];
	}

	DbCollectionTableComponent(this._stitch, this._modalService)
	{
		getPage();
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
			if(customFieldTypes[field].runtimeType.toString() == 'List<String>')
				type = customFieldTypes[field].runtimeType.toString();
			// use vlue of the member as type
			else type = customFieldTypes[field]; 
		}

		return type;
	}

	bool getActiveStatus(String field)
	{
		bool isActive = true;

		if(disables != null) disables.forEach((item) {
			if(field == item) isActive = false;
		});

		return isActive;
	}

	void showForm(String type, [dynamic selected])
	{
		editable = selected ?? {};
		formType = type;

		_modalService.show(modalName);
	}

	void search()
	{
		try{
			_query = json.decode(searchQuery);
			getPage();
		}
		catch(e){
			_query = {};
			searchQuery = '';
		}
	}

	void setPage(String enteredPage)
	{
		int tempPage = int.tryParse(enteredPage);
		if(tempPage != null) getPage(page: tempPage);
	}

	void navigate(int value) => getPage(navigate: value);

	void getPage({int page, int navigate}) async
	{
		// get collection
		if(_collection == null){
			await Future.delayed(Duration(seconds:1));
			_collection = _stitch.dbClient.db(dataBase).collection(collection);
		}

		if(page != null) current_page = page;
		if(navigate != null) current_page += navigate;

		// get total items
		await promiseToFuture(_collection.count(_query))
		.then((count) {
			total = count;
		}).catchError(_catchError);

		// setup navigator option
		Map avigatorDetail = getNavigatorDetail(
								total: total, 
								page: current_page, 
								perPage: perPage);

		// aggregate pipline
		List<dynamic> pipline = [
			_query,
			{"\$skip": avigatorDetail['from']},
			{"\$limit": avigatorDetail['to']},
			{"\$sort": { '_id': -1 } },
		];

		// remove query pipline if it doesn't has
		if(getKeies(js.jsify(_query)).length == 0)
			pipline.removeAt(0);

		// get by aggregate
		await promiseToFuture(_collection.aggregate(js.jsify(pipline)).asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic document = documents[i];

				// crate fields if dont exists
				List<String> keies = getKeies(document, removes: ['_id']);
				if(fields.length < keies.length) fields = keies;

				// add item to list for presenting
				dynamic item = convertFromJS(document);
				list.add(item);
			}
		}).catchError(_catchError);

		print('items gotten, ${list.length}');
	}

	void addNewItem() async
	{
		// normaliz
		editable = normalize(editable);

		dynamic newItem = js.jsify(editable);

		await promiseToFuture(_collection.insertOne(newItem))
		.then((document) {
			getPage();
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
			getPage();
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
			getPage();
			modal.close();
		})
		.catchError(printError);
	}

	dynamic normalize(dynamic object)
	{
		dynamic normalized = {};

		getKeies(js.jsify(object)).forEach((key) 
		{
			//print('key $key');

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

	void _catchError(error){
		print(error.toString());
	}
}
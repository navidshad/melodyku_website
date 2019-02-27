import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:convert';

import 'package:js/js_util.dart' as js;

import '../../../services/stitch_service.dart';
import '../../../services/modal_service.dart';

import '../../../class/modal/modal.dart';

import '../../../class/utility/db_collection_table_options.dart';
export '../../../class/utility/db_collection_table_options.dart';

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
	List<LinkButton> linkButtons = [];

	List<dynamic> list = [];
	dynamic editable;
	dynamic searchQuery;
	dynamic _mainQuery = {};
	dynamic _searchQuery = {};

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
	void set options(DbCollectionTableOptions options)
	{
		if(options.fields != null) 	 	fields = options.fields;
		if(options.types != null) 	 	customFieldTypes = options.types;
		if(options.disables != null) 	disables = options.disables;
		if(options.linkButtons != null)	linkButtons = options.linkButtons;
		if(options.query != null)		_mainQuery = options.query;
		
		if(options.allowAdd != null) 	couldAdd = options.allowAdd;
		if(options.allowUpdate != null) couldUpdate = options.allowUpdate;
		if(options.allowRemove != null) couldRemove = options.allowRemove;
		if(options.allowQuery != null) 	couldQuery = options.allowQuery;
		if(options.hasNavigator != null) hasNavigator = options.hasNavigator;
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
			_searchQuery = json.decode(searchQuery);
			getPage();
		}
		catch(e){
			_searchQuery = {};
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
		//print('_mainQuery $_mainQuery');
		await promiseToFuture(_collection.count(js.jsify(_mainQuery)))
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
			{"\$match": _mainQuery},
			{"\$match": _searchQuery},
			{"\$skip": avigatorDetail['from']},
			{"\$limit": avigatorDetail['to']},
			{"\$sort": { '_id': -1 } },
		];
		
		//print('pipline $pipline');

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
				if(fields.length == 0) fields = keies;

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

		//print('updating ${editable['_id']}');

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

		//print('deleting ${editable['_id']}');

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
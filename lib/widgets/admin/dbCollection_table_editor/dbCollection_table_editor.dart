/// {@nodoc}
library dbCollectionTableEditor;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'package:js/js_util.dart' as js;

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector: 'db-collection-table-editor',
	templateUrl: 'dbCollection_table_editor.html',
	styleUrls: ['dbCollection_table_editor.css'],
	directives: [
		coreDirectives,
		formDirectives,
    	ElementExtractorDirective,
    	DbCollectionItemEditorComponent,
    	ButtonRounded,
	]
)
class DbCollectionTableEditorComponent implements OnChanges
{
	ModalService _modalService;
  	Modal modal;

	MongoDBService _mongodb;

	CollectionOptions editableItemOptions;

	List<dynamic> list = [];
	dynamic editable;

	dynamic searchQuery;
	Map<String, dynamic> _searchQuery = {};

	String modalName;
	String formType;

	int perPage = 25;
	int total_items = 0;
	int total_pages = 0;
	int current_page = 1;

	set totalPerPage(String val)
	{
		try{
			int temp = int.tryParse(val);
			perPage = temp;
			getPage(page:1);
		}catch(e){

		}
	}

	@Input()
	CollectionOptions options;

	DbCollectionTableEditorComponent(this._mongodb, this._modalService);

	ngOnChanges(dynamic changes)
	{
		if(options != null)
		{
			if(options.autoGet) getPage();

			options.clearStream.listen(clearList);
		}
	}

	void clearList([dynamic data]) =>
		list = [];

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modalName = '${options.title}_modal';

		modal = Modal(el);
		_modalService.register(modalName, modal);
	}

	void showForm([dynamic selected])
	{
		editable = selected ?? {};

		print(editable);

		// setup for new Item
		if(selected == null)
		{
			editableItemOptions = CollectionOptions(
				createNew: true,
				addOnCreate:options.addOnCreate,
				document: editable,
				database: options.database,
				collection: options.collection,
				dbFields: options.dbFields,
				allowRemove: options.allowRemove,
				hasCover: options.hasCover,
				showHidenField: options.showHidenField,
			);
		}

		// setup for edit selected item
		else {
			editableItemOptions = CollectionOptions(
				database: options.database,
				collection: options.collection,
				id: editable['_id'].toString(),
				dbFields: options.dbFields,
				allowRemove: options.allowRemove,
				hasCover: options.hasCover,
				showHidenField: options.showHidenField,
			);
		}

		_modalService.show(modalName);
	}

	void search()
	{
		try{
			_searchQuery = json.decode(searchQuery);
			if(options.autoGet) getPage();
		}
		catch(e){
			_searchQuery = {};
			searchQuery = '';
		}
	}

	void setPage(String enteredPage)
	{
		int tempPage = int.tryParse(enteredPage);
		if(tempPage != null && options.autoGet)
			getPage(page: tempPage);
	}

	void navigate(int value) => getPage(navigate: value);

	Map<String, dynamic> getSearchQuery()
	{
		Map<String, dynamic> tempQuery;

		if(_searchQuery.keys.length > 0)
			tempQuery = {};

		_searchQuery.keys.forEach((key) 
			=> tempQuery[key] = { '\$regex': _searchQuery[key], '\$options':'ig'});

		return tempQuery;
	}

	void getPage({int page, int navigate}) async
	{
		clearList();

		if(page != null) current_page = page;
		if(navigate != null) current_page += navigate;

		// combine queries objects 
		Map<String, dynamic> combinedQueries = options.query;

		// add search query
		// inject searcjQuery if options.query is raw
		if(combinedQueries.keys.length == 0)
			combinedQueries = getSearchQuery() ?? {};
		// else combine custom with search query
		else if(getSearchQuery() != null)
			combinedQueries.addAll(getSearchQuery());

		// get total items
		//print('_mainQuery $_mainQuery');
    	await _mongodb.count(
	    		isLive:true, 
	    		database: options.database, 
	      		collection: options.collection, 
	      		query: combinedQueries, 
	      		types: options.types
      		)
			.then((count)
			{
				total_items = count;
				total_pages = (total_items / perPage).ceil();
			}).catchError(_catchError);

		// setup navigator option
		Map avigatorDetail = getNavigatorDetail(
								total: total_items, 
								page: current_page, 
								perPage: perPage);

		// aggregate pipline
		List<Map> piplines = 
		[	
			// query
			{"\$match": combinedQueries},
			// sort
			{
				"\$sort": options.sort ?? { '_id': -1 } 
			},
			
			// navigator
			{"\$skip": avigatorDetail['from']},
			{"\$limit": avigatorDetail['to']},
		];
		
		//print('pipline for ${_collection.namespace} $pipline');

		// get by aggregate
    		await _mongodb.aggregate(
	    		isLive:true, database: 
	    		options.database, 
	    		collection: options.collection,
			piplines: piplines,
		     types: options.types
	    	)
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
			  dynamic document = documents[i];

			  Map converted = validateFields(document, options.dbFields);
			  list.add(converted);
			}
		}).catchError(_catchError);

		print('items gotten, ${list.length}');
	}

	void onChanchedItem(bool changed)
	{
		//if(changed) modal.close();
		getPage();
	}

	void removeItem(Map item) async
	{
		// confirm operation by user
		bool confirmation = window.confirm('are you sure that you want to remove this item?');

		if(!confirmation) return;

		// create remove query
		dynamic query = {'_id': item['_id']};

    	_mongodb.removeOne(isLive:true, database: options.database, collection: options.collection, query: query)
	      .then((d)
	      {
	        getPage();
	        modal.close();
	        getPage();
	      })
	      .catchError(printError);
	}

	void printError(error)
	{
		//print(error);
		modal.addMessage(error.toString(), color: 'red');
		modal.showMessage();
		modal.doWaiting(false);
	}

	void _catchError(error){
		print(error.toString());
	}
}
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
import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'db-collection-table-editor',
	templateUrl: 'dbCollection_table_editor.html',
	styleUrls: ['dbCollection_table_editor.css'],
	directives: [
		coreDirectives,
		formDirectives,
    	ElementExtractorDirective,
    	DbCollectionItemEditorComponent,
	]
)
class DbCollectionTableEditorComponent
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	CollectionOptions options;
	CollectionOptions editableItemOptions;

	List<dynamic> list = [];
	dynamic editable;

	dynamic searchQuery;
	Map<String, dynamic> _searchQuery = {};

	String modalName;
	String formType;

	int perPage = 10;
	int total = 0;
	int total_pages = 0;
	int current_page = 1;

	@Input('options')
	void set setOptions(CollectionOptions value)
	{
		options = value;
		getPage();
	}

	DbCollectionTableEditorComponent(this._stitch, this._modalService);

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
			_collection = _stitch.dbClient.db(options.database).collection(options.collection);
		}

		if(page != null) current_page = page;
		if(navigate != null) current_page += navigate;

		// combine queries objects 
		dynamic combinedQueries = options.query ?? {};

		_searchQuery.keys.forEach((key) {
				if(!_searchQuery.containsKey(key)) combinedQueries[key] = _searchQuery[key];
			});

		// get total items
		//print('_mainQuery $_mainQuery');
		await promiseToFuture(_collection.count(js.jsify(combinedQueries)))
			.then((count)
			{
				total = count;
				total_pages = (total / perPage).ceil();
			}).catchError(_catchError);

		// setup navigator option
		Map avigatorDetail = getNavigatorDetail(
								total: total, 
								page: current_page, 
								perPage: perPage);

		// aggregate pipline
		List<dynamic> pipline = [
			// {"\$match": _mainQuery},
			// {"\$match": _searchQuery},
			{"\$match": combinedQueries},
			{"\$skip": avigatorDetail['from']},
			{"\$limit": avigatorDetail['to']},
			{"\$sort": { '_id': -1 } },
		];
		
		print('pipline for ${_collection.namespace} $pipline');

		// get by aggregate
		await promiseToFuture(_collection.aggregate(js.jsify(pipline)).asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic document = documents[i];

				Map converted = convertToMap(document, options.dbFields);
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
		dynamic query = js.jsify({'_id': item['_id']});

		await promiseToFuture(_collection.deleteOne(query))
		.then((d){
			log(d);
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
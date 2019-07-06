/// {@nodoc}
library mediaLanguageSetting;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:js/js_util.dart' as js;

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/mongo_stitch/mongo_stitch.dart';

@Component(
	selector: 'medai-lang-settings',
	templateUrl: 'media_language_settings.html',
	styleUrls: ['media_language_settings.css'],
	directives: [
		coreDirectives,
		formDirectives,
		ElementExtractorDirective,
	]
)
class mediaLanguageSettingsComponent 
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoDatabase _mediadb;

	List<dynamic> list = [];

	List<String> titles = [
		'title', 
		'title en',
		'code',
		'is default',
		'options'
	];

	dynamic editable;
	String formType = 'add';

	mediaLanguageSettingsComponent(this._stitch, this._modalService)
	{
		_mediadb = _stitch.dbClient.db('media');
		getLanguages();
	}

	getLanguages() async
	{
		await promiseToFuture(_mediadb.collection('language').find().asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				// dynamic language = convertFromJS(documents[i]);
				// list.add(language);
			}
		}).catchError((e)
		{
			print(e);
		});

		print('languages gotten, ${list.length}');
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modal = Modal(el);
		_modalService.register('add_media_language', modal);
	}

	void showForm(String type, [dynamic language])
	{
		editable = language ?? {};
		formType = type;
		_modalService.show('add_media_language');
	}

	void addNewLanguage() async
	{
		dynamic newLanguage = js.jsify(
		{
			'title'		: editable['title'],
			'title_en' 	: editable['title_en'],
	        'code'      : editable['code'],
	        'isDefault'	: editable['isDefault'],
		});

		await promiseToFuture(_mediadb.collection('language').insertOne(newLanguage))
		.then((document) {
			modal.close();
			getLanguages();
			print(document.toString());
		})
		.catchError((error){
			modal.addMessage(error, color: 'red');
			modal.showMessage();
			modal.doWaiting(false);
			//print(error);
		});		
	}

	void updateLanguage() async
	{
		modal.doWaiting(true);

		print('updating ${editable['_id']}');

		dynamic query = js.jsify({'_id': editable['_id']});

		dynamic update = js.jsify({
			'\$set': {
				'title'				: editable['title'],
				'isDefault'			: editable['isDefault'],
				'advanced_settings' : editable['title_en'],
		        'code'      : editable['code'],
			}
		});

		await promiseToFuture(_mediadb.collection('language').updateOne(query, update))
		.then((d){
			log(d);
			modal.close();
			getLanguages();
		})
		.catchError((error){
			modal.addMessage(error, color: 'red');
			modal.showMessage();
			modal.doWaiting(false);
			//print(error);
		});
	}

	void deleteLanguage() async
	{
		modal.doWaiting(true);

		print('deleting ${editable['_id']}');

		dynamic query = js.jsify({'_id': editable['_id']});

		await promiseToFuture(_mediadb.collection('language').deleteOne(query))
		.then((d){
			log(d);
			modal.close();
			getLanguages();
		})
		.catchError((error){
			modal.addMessage(error, color: 'red');
			modal.showMessage();
			modal.doWaiting(false);
			//print(error);
		});
	}
}
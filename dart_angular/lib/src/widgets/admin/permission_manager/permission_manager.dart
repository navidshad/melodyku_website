import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import 'package:js/js_util.dart' as js;

import '../../../services/stitch_service.dart';
import '../../../services/modal_service.dart';

import '../../../class/user/permission.dart';
import '../../../class/modal/modal.dart';

import '../../../directives/ElementExtractorDirective.dart';

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'permission-manager',
	templateUrl: 'permission_manager.html',
	styleUrls: ['permission_manager.scss.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
	]
)
class PermissionManagerComponent 
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoDatabase _userdb;

	List<Permission> list = [];

	List<String> titles = [
		'title', 
		'isDefault',
		'customer access',
		'archive manager',
		'categorizing',
		'user manager',
		'quality management',
		'advanced settings',
		'options'
	];

	Permission newPer;
	String formType = 'add';

	PermissionManagerComponent(this._stitch, this._modalService)
	{
		_userdb = _stitch.dbClient.db('user');
		getPermissions();
	}

	void getPermissions() async
	{
		await promiseToFuture(_userdb.collection('permission').find().asArray())
		.then((documents) 
		{
			list = [];	

			for(int i=0; i < documents.length; i++)
			{
				dynamic detail = convertFromJS(documents[i]);
				Permission pr = Permission.fromJson(detail);
				list.add(pr);
			}
		});

		print('permission gotten, ${list.length}');
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modal = Modal(el);
		_modalService.register('add_permission', modal);
	}

	void showForm(String type, [Permission editable])
	{
		newPer = editable ?? new Permission.lessAccess();
		formType = type;
		_modalService.show('add_permission');
	}

	void addNewPermission() async
	{
		

		dynamic newPermission = js.jsify({
			'title'				: newPer.title,
			'isDefault'			: newPer.isDefault,
			'advanced_settings' : newPer.advanced_settings,
	        'categorizing'      : newPer.categorizing,
	        'archive_manager'   : newPer.archive_manager,
	        'customer_access'   : newPer.customer_access,        
	        'quality_management': newPer.quality_management,
	        'user_manager'      : newPer.user_manager,
		});

		await promiseToFuture(_userdb.collection('permission').insertOne(newPermission))
		.then((document) {
			modal.close();
			getPermissions();
		})
		.catchError((error){
			print(error);
		});		
	}

	void updatePermission() async
	{
		modal.doWaiting(true);

		print('updating ${newPer.id}');

		dynamic query = js.newObject();
		js.setProperty(query, '_id', newPer.id);

		dynamic update = js.jsify({
			'\$set': {
				'title'				: newPer.title,
				'isDefault'			: newPer.isDefault,
				'advanced_settings' : newPer.advanced_settings,
		        'categorizing'      : newPer.categorizing,
		        'archive_manager'   : newPer.archive_manager,
		        'customer_access'   : newPer.customer_access,        
		        'quality_management': newPer.quality_management,
		        'user_manager'      : newPer.user_manager,
			}
		});

		await promiseToFuture(_userdb.collection('permission').updateOne(query, update))
		.then((d){
			print(convertFromJS(d));
			modal.close();
			getPermissions();
		})
		.catchError((error){
			print(error);
		});
	}

	void deletePermission() async
	{
		modal.doWaiting(true);

		print('deleting ${newPer.id}');

		dynamic query = js.newObject();
		js.setProperty(query, '_id', newPer.id);

		await promiseToFuture(_userdb.collection('permission').deleteOne(query))
		.then((d){
			print(convertFromJS(d));
			modal.close();
			getPermissions();
		})
		.catchError((error){
			print(error);
		});
	}
}

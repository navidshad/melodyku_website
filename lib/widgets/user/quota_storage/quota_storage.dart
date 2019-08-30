import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/indexeddb/indexeddb.dart';
import 'package:melodyku/pips/pips.dart';


@Component(
	selector: 'quota',
	templateUrl: 'quota_storage.html',
	styleUrls: ['quota_storage.css'],
	directives: [
		DirectionDirective,
	],
	pipes: [
		BytesToMb,
	]
)
class QuotaUsageComponent
{
	IndexedDBService _indexedDB;
	LanguageService lang;

	StorageQuta get storageQuota => _indexedDB.storageQuota;

	QuotaUsageComponent(this._indexedDB, this.lang)
	{
		print(_indexedDB.storageQuota.getInfoMap());

	}

	void onGetContainer(Element container)
	{

	}
}
import 'package:angular/angular.dart';
import 'dart:convert';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/js_interop/js_interop.dart';

@Component(
	selector: 'quota',
	templateUrl: 'quota_storage.html',
	styleUrls: ['quota_storage.css'],
	directives: [

	]
)
class QuotaUsage
{
	IndexedDBService _indexedDB;
	LanguageService lang;

	Map quota;

	QuotaUsage(this._indexedDB, this.lang)
	{
		// _indexedDB.getStorageQuotaInfo()
		// 	.then((dynamic info) => log(info))
		// 	.catchError((err) => print(err));
	}
}
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

import 'package:melodyku/mongo_stitch/app_client.dart';

@Component(
	selector: 'cover-item-editor',
	templateUrl: 'cover_item_editor.html',
	styleUrls: ['cover_item_editor.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
		formDirectives,
	]
)
class CoverItemEditor
{
	ModalService _modalService;
  	Modal modal;

	StitchService _stitch;
	RemoteMongoCollection _collection;

	CoverItemEditor(this._stitch, this._modalService)
	{
		
	}
}
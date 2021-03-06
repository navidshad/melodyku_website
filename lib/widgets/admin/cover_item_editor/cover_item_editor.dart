/// {@nodoc}
library coverItemEditor;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:async';

import 'package:melodyku/services/services.dart';

@Component(
	selector: 'cover-item-editor',
	templateUrl: 'cover_item_editor.html',
	styleUrls: ['cover_item_editor.css'],
	directives: [
		coreDirectives,
		formDirectives,
	]
)
class CoverItemEditor implements OnInit
{
	final eventController = StreamController<bool>();
	ContentProvider _contentProvider;

	CoverItemEditor(this._contentProvider);

	void ngOnInit() async
	{
		if(type == null || id == null) return;

		getNewLink();
	}

	String stamp;
	String link = '';
	String progress = '';
	bool isUploading = false;

	@Input()
	String type;

	@Input()
	String database;

	@Input()
	String id;

	@Input()
	void set imgStamp(String value)
	{
		stamp = value;
		getNewLink();
	}

	@Output()
	Stream get onChanged => eventController.stream;

	void getNewLink(){
		link = _contentProvider.getImage(database: database, type: type, id: id, imgStamp: stamp);
	}

  	void uploadFiles(FormElement form) 
  	{
  		if(isUploading) return;

  		isUploading = true;

	    _contentProvider.uploadImage(
	    	database: database,
	    	type: type,
	    	id: id,
	    	form: form, 
	    	onProgress: (ProgressEvent e) {
      			progress = (e.loaded*100/e.total).toInt().toString() + '%';
    		})
	    	.then((r) {
	    		progress = '';
    			eventController.add(true);
    			isUploading = false;
	    	})
	    	.catchError((err) {
	    		progress = '';
    			isUploading = false;
	    	});
  	}

  	void removeImage()
  	{
  		if(isUploading) return;

  		isUploading = true;

  		_contentProvider.removeImage(database: database, type: type, id:id)
  			.then((body) {	
				print('image has been removed $body');
				eventController.add(true);
				isUploading = false;
			})
			.catchError((err) {
				print('image remover has error $err');
				isUploading = false;
			});
  	}
}
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';

import '../../../services/services.dart';


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
	ContentProvider _contentProvider;

	CoverItemEditor(this._contentProvider);

	void ngOnInit() async
	{
		print('ngOnInit');
		if(type == null || id == null) return;

		link = await _contentProvider.getImage(type: type, id: id, imgStamp: imgStamp);
	}

	String link = '';

	@Input()
	String type;

	@Input()
	String id;

	@Input()
	String imgStamp;

	String progress = '';
  	void uploadFiles(form) 
  	{
	    FormData formData = new FormData(form);

	    formData.append('type', type);
	    formData.append('id', id);

	    print('$type $id');

	    //String link = '${window.location.origin}/image/upload';
	    String link = 'http://steryo.melodyku.com/image/upload';

		final request = new HttpRequest();
	    request.open('POST', link);

	    request.upload.onProgress
	    	.listen((ProgressEvent e) {
      			progress = (e.loaded*100/e.total).toInt().toString() + '%';
    		});

	    request.onLoad
	    	.listen((result) async {
    			print('image has been uploaded $result');
    			progress = '';
    			link = await _contentProvider.getImage(type: type, id: id);
    		});

	    request.onError
	    	.listen((error) {
    			print('image upload has error $error');
    			progress = '';
    		});

	    request.send(formData);
  	}
}
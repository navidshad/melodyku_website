import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:async';

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
	final eventController = StreamController<bool>();
	ContentProvider _contentProvider;

	CoverItemEditor(this._contentProvider);

	void ngOnInit() async
	{
		print('ngOnInit');
		if(type == null || id == null) return;

		getNewLink();
	}

	String stamp;
	String link = '';
	bool isUploading = false;

	@Input()
	String type;

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
		_contentProvider.getImage(type: type, id: id, imgStamp: stamp)
			.then((newLink) => link = newLink);
	}

	String progress = '';
  	void uploadFiles(form) 
  	{
  		if(isUploading) return;

  		isUploading = true;
	    FormData formData = new FormData(form);

	    formData.append('type', type);
	    formData.append('id', id);

	    print('$type $id');

	    String link = '${window.location.origin}/image/upload';
	    //String link = 'http://steryo.melodyku.com/image/upload';

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
    			eventController.add(true);
    			isUploading = false;
    		});

	    request.onError
	    	.listen((error) {
    			print('image upload has error $error');
    			progress = '';
    			isUploading = false;
    		});

	    request.send(formData);
  	}

  	void removeImage()
  	{
  		if(isUploading) return;

  		isUploading = true;

  		FormData formData = new FormData();

  		formData.append('type', type);
	    formData.append('id', id);

	    String link = '${window.location.origin}/image/upload';
		//String link = 'http://steryo.melodyku.com/image/remove';

	    final request = new HttpRequest();
	    request.open('POST', link);

	    request.onLoadEnd
	    	.listen((result) async {
    			print('image has been removed $result');
    			eventController.add(true);
    			isUploading = false;
    		});

	    request.onError
	    	.listen((error) {
    			print('image remover has error $error');
    			isUploading = false;
    		});

	    request.send(formData);
  	}
}
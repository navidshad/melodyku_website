import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'dart:html';
import 'dart:async';

import 'package:melodyku/services/services.dart';

@Component(
	selector: 'image-uploader',
	template: '''
		<div class="options flex-row">
			<form #form enctype="multipart/form-data">

		    	<input class="btn-sl pick" type="file" #upload name='image'>
				
		    	<div class="flex-row flex-center">
					<div class="btn-sl {{isUploading ? 'btn-disabled': ''}}" 
						 (click)="uploadFiles(form)">upload {{progress}}</div>
						 
					<div class="btn-close {{isUploading ? 'btn-disabled': ''}}" 
						 (click)="removeImage()">
						<img src="/assets/svg/icon_close.svg">
					</div>
				</div>
		  	</form>
		</div>
	''',
	styles: [ '''
		.options {
			margin: 10px 0px;
		}

		.pick{
			max-width: 200px;
		    padding: 0;
		}
	'''],
	directives: [
		coreDirectives,
		formDirectives,
	]
)
class ImageUploaderComponent 
{
	final eventController = StreamController<String>();
	ContentProvider _contentProvider;

	String progress = '';
	bool isUploading = false;

	@Input()
	String type;

	@Input()
	String database;

	@Input()
	String id;

	@Output()
	Stream get onUploaded => eventController.stream;

	ImageUploaderComponent(this._contentProvider);

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
	    	.then((stamp) {
	    		progress = '';
    			isUploading = false;
    			eventController.add(stamp);
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
				isUploading = false;
			})
			.catchError((err) {
				print('image remover has error $err');
				isUploading = false;
			});
  	}
}

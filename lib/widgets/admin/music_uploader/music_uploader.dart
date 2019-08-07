import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/filepond/filepond.dart';
import 'package:melodyku/js_interop/js_interop.dart';


@Component(
	selector: 'music-uploader',
	templateUrl: 'music_uploader.html',
	styleUrls: ['music_uploader.css'],
	directives: [
		coreDirectives,
		ElementExtractorDirective,
	]
)
class musicUploaderComponent
{
	UserService _userService;

	@Input()
	Map album;

	FilePondInstance pond;

	musicUploaderComponent(this._userService);

	String getTitle() =>
		'${album['artist']} - ${album['title']}';

	void getElement(Element el)
	{
		FilePond.registerPlugin(FilePondPluginFileMetadata);
		pond = FilePond.create(el);

		pond.setOptions(jsify(
		{
			'server': {
				'url': Vars.host + '/music/upload',
				'process': {
					'headers': {
						'authorization': _userService.token,
					}
				}
			},

			'allowMultiple': true,
			'maxFiles': 20,
			'maxParallelUploads': 2,

			'fileMetadataObject': {
				'albumId': album['_id']
			},
		}));
	}
}
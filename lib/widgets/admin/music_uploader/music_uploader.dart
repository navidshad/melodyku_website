import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:convert';

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
	],
)
class musicUploaderComponent
{
	ChangeDetectorRef changeDetector;
	UserService _userService;

	@Input()
	Map album;

	FilePondInstance pond;

	Element errorsSection;

	musicUploaderComponent(this.changeDetector, this._userService);

	String get title =>
		'${album['artist']} - ${album['title']}';

	void setupFilePond(Element inputElement)
	{
		FilePond.registerPlugin(FilePondPluginFileMetadata);
		pond = FilePond.create(inputElement);

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

		//pond.server.process.onerror = onError;
	}

	void getErrorSection(Element el)
	{
		errorsSection = el;
	}

	Function onError(dynamic body) 
	{
		print('printError');
		Map songDetail = json.decode(body);

	 	DivElement block = DivElement();
		UListElement ul = UListElement();

	 	List<String> keys = songDetail.keys.toList();

		for(int i =0; i < keys.length; i++)
		{
		   String key = keys[i];
			Element li = Element.li();

		   Element title = Element.span();
		   title.style.color = 'grey';
		   title.text = '$key: ';

		   li.append(title);
		   li.appendHtml('<span>${songDetail[key]}</span>');
		   ul.append(li);
		}

		block.append(ul);
		errorsSection.append(block);

		block.style.setProperty('border', '1px solid red');
		block.style.setProperty('border-radius', '10px');
		block.style.setProperty('width', '100%');
		block.style.setProperty('margine', '5px 0px');
	}

	void clearAll()
	{
		pond.removeFiles();
		errorsSection.children = [];
	}
}
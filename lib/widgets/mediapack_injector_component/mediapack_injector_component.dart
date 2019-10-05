import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'packmediaInjector',
	templateUrl: 'mediapack_injector_component.html',
	styleUrls: ['mediapack_injector_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		DirectionDirective,
	]
)
class MediaPackInjectorComponent implements OnChanges
{
	PopupService popupService;
	MongoDBService _mongodb;
	LanguageService lang;

	List<MediaPackEditor> mediaPacks = [];

	@Input()
	dynamic item = '';

	MediaPackInjectorComponent(this.popupService, this._mongodb, this.lang)
	{
		
	}

	void ngOnChanges(Map<String, SimpleChange> changes)
	{
		getItems();
	}

	String getType()
	{
		String type;
		ArchiveTypes archiveTypes = item.type;

		switch(archiveTypes)
		{
			case ArchiveTypes.artist: type = 'artists'; break;
			case ArchiveTypes.album: type = 'albums'; break;
			case ArchiveTypes.playlist: type = 'playlists'; break;
			case ArchiveTypes.song: type = 'songs'; break;
		}

		return type;
	}

	void getItems()
	{
		Map query = { 
			'forGenerator': false,
			'type': getType(),
		};
		
		_mongodb.find(isLive: true, database: 'media', collection: 'media_pack', query: query)
		.then((docs) 
		{
			docs.forEach((doc)
			{
				Map validated = validateFields(doc, SystemSchema.mediaPack);
				MediaPackEditor me = MediaPackEditor.fromMap(validated);
				if(me != null) mediaPacks.add(me);
			});
		});
	}
}
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'playlistInjector',
	templateUrl: 'playlist_injector_component.html',
	styleUrls: ['playlist_injector_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		DirectionDirective,
	]
)
class PlaylistInjectorComponent
{
	PopupService popupService;
	MongoDBService _mongodb;
	LanguageService lang;

	List<PlaylistEditor> playlists = [];

	@Input()
	String songid = '';

	PlaylistInjectorComponent(this.popupService, this._mongodb, this.lang)
	{
		getPlaylists();
	}

	void getPlaylists()
	{
		Map query = { 'forGenerator': false };
		
		_mongodb.find(isLive: true, database: 'media', collection: 'playlist', query: query)
		.then((docs) 
		{
			docs.forEach((doc)
			{
				Map validated = validateFields(doc, SystemSchema.playlist);
				PlaylistEditor pl = PlaylistEditor.fromMap(validated);
				if(pl != null) playlists.add(pl);
			});
		});
	}
}
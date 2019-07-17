/// {@nodoc}
library SearchComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';


import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';

@Component(
	selector: 'search',
	templateUrl: 'search_component.html',
	styleUrls: ['search_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		GridComponent,
		ListWideComponent,
	],
)
class SearchComponent
{
	LanguageService lang;
	MongoDBService _mongodb;

	SearchComponent(this.lang, this._mongodb);

	String type = 'song';
	String word = '';
	bool nothingFound = false;

	Aggregate aggregator;

	List<Card> cards_artist = [];
  	List<ListItem> listItems_song = [];

	void changeType(String t) {
		type = t;
		aggregator = null;
		search();
	}

	void search() async
	{
		if(word.trim().length == 0) return;

		word = word.toLowerCase();

		nothingFound = false;

		cards_artist = [];
		listItems_song = [];

		List<Map> or = [ {'title': { '\$regex': '$word'}} ];

		lang.getCodes().forEach((code) 
			=> or.add({'local_title.$code': { '\$regex': '$word'} } ));

		List<Map> pipline = [
			{
				'\$match': { '\$or' : or }
			},
			{
				'\$sort': { 'title': 1 }
			}
		];

		print(pipline);

		if(type == 'artist') {
			aggregator = Aggregate(
        database: 'media',
				collection: 'artist',
				pipline: pipline);
		}

		else if(type == 'song') {
			aggregator = Aggregate(
				database: 'media',
				collection: 'song',
				pipline: pipline);
		}

		await aggregator.initialize();
		loadNextPage();
	}

	void loadNextPage() async
	{
		aggregator.loadNextPage()
		.then((docs) 
		{
			if(docs.length == 0) nothingFound = true;

			docs.forEach((doc) 
			{
				if(type == 'artist')
				{
					Map converted = validateFields(doc, SystemSchema.artist);
					Artist artist = Artist.fromjson(converted);
					cards_artist.add(artist.getAsWidget<Card>());
				}
				else if(type == 'song')
				{
					Map converted = validateFields(doc, SystemSchema.song);
					Song song = Song.fromjson(converted);
					listItems_song.add(song.getAsWidget<ListItem>());
				}
			});
		});
	}
}
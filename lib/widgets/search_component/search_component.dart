/// {@nodoc}
library SearchComponent;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';


import 'package:melodyku/core/core.dart';
import 'package:melodyku/pips/pips.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/mongodb/media_lookup_piplines.dart' as lookup;

@Component(
	selector: 'search',
	templateUrl: 'search_component.html',
	styleUrls: ['search_component.css'],
	directives: [
		coreDirectives,
		formDirectives,
		GridComponent,
		ListWideComponent,
		WidgetLoading,
		ButtonCircle,
	],
	pipes: [
    TitlePipe,
   ]
)
class SearchComponent
{
	LanguageService lang;
	MongoDBService _mongodb;
	AnalyticService _analytic;

	ButtonOptions sBtnOptions;

	SearchComponent(this.lang, this._mongodb, this._analytic)
	{
		sBtnOptions = ButtonOptions(
			type: ButtonType.sl_x, 
			callback: onPressSearchButton,
			icon: '/assets/svg/icon_search.svg');
	}

	String type = 'song';
	String word = '';
	bool nothingFound = false;

	Aggregate aggregator;

	List<Card> cards_artist = [];
  	List<ListItem> listItems_song = [];

  	bool isPending = false;

	void changeType(String t) 
	{
		type = t;
		aggregator = null;

		onPressSearchButton();
	}

	Function onPressSearchButton([ButtonOptions btnOp])
	{
		if(btnOp == null) btnOp = sBtnOptions;

		if(word.trim().length == 0) return null;

		btnOp.doWaiting(true);
		btnOp.setActivation(false);
		
		search().then((r) {
			btnOp.doWaiting(false);
			btnOp.setActivation(true);
		});
	}

	Future<void> search()
	{
		isPending = true;

		word = word.toLowerCase().trim();

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

		if(type == 'artist') 
		{
			aggregator = Aggregate(
        		database: 'media',
				collection: 'artist',
				pipline: pipline
			);
		}

		else if(type == 'song') 
		{
			pipline.addAll(lookup.getPiplines('song'));

			aggregator = Aggregate(
				database: 'media',
				collection: 'song',
				pipline: pipline
			);
		}

		return aggregator.initialize()
			.then((r) => loadNextPage());
	}

	void loadNextPage() async
	{
		aggregator.loadNextPage()
		.then((docs) 
		{
			if(docs.length == 0) nothingFound = true;

			int counter = 0;
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
					Map converted = validateFields(doc, SystemSchema.song_populateVer);
					Song song = Song.fromPopulatedDoc(converted);
					ListItem lItem = song.getAsWidget<ListItem>(itemNumber: counter);
					listItems_song.add(lItem);
				}

				counter++;
			});

			return docs.length;
		})
		.then((int total) 
		{
			isPending = false;
			_analytic.trackEvent(
				'searching $type', 
				category: 'search', 
				label: word, 
				value: '$total result');
		});
	}
}
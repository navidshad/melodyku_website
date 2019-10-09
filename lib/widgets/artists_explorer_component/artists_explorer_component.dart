/// {@nodoc}
library artistExplorerComponent;

import 'package:angular/angular.dart';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';
import 'characters.dart';

@Component(
	selector: 'artist-explorer',
	templateUrl: 'artists_explorer_component.html',
	styleUrls: ['artists_explorer_component.css'],
	directives: [
		coreDirectives,
		GridComponent,
	],
)
class ArtistsExplorerComponent
{
	String selected = '';
	bool couldLoadMore = false;
	int _perPage = 20;

	List<Card> artistCards = [];
	Aggregate agregator;
	

	LanguageService lang;

	ArtistsExplorerComponent(this.lang);

	List<String> getCharacters()
	{
		List<String> list = characters[lang.getCode()] as List<String>;
		return list;
	}

	void selectChar(String char)
	{
		selected = char;
		getArtists();
		artistCards = [];
	}

	Map getMatchStage()
	{
		return {
			'\$match': {
				'\$or' : [
					{ 'local_title.${lang.getCode()}': { '\$regex': '^$selected' } },
					{ 'name': { '\$regex': '^$selected' } },
				]
			}
		};
	}

	void getArtists() async
	{
		agregator = Aggregate(
      database: 'media',
			collection: 'artist', 
			pipline: [getMatchStage()], 
			perPage: _perPage);

		await agregator.initialize();
		loadNextPage();
	}

	void loadNextPage() async
	{
		List<dynamic> artistDocs = await agregator.loadNextPage();

		artistDocs.forEach((doc) 
			{
				Map map = validateFields(doc, SystemSchema.artist);
				Artist artist = Artist.fromjson(map);
				artistCards.add(artist.getAsWidget<Card>());
			});

		couldLoadMore = agregator.hasMore;
	}
}
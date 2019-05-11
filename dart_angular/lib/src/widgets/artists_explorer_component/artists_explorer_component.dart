import 'dart:async';
import 'package:angular/angular.dart';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/class/classes.dart';
import 'package:melodyku/src/widgets/grid_component/grid_component.dart';
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
	String selected = 'a';
	bool couldLoadMore = false;
	int _totalItems = 0;
	int _perPage = 20;
	int _page = 0;

	List<Card> artistCards = [];

	LanguageService lang;
	StitchService _stitch;
	RemoteMongoCollection _artistColl;

	ArtistsExplorerComponent(this.lang, this._stitch)
	{
		_artistColl= _stitch.dbClient.db('media').collection('artist');
		getArtists();
	}

	List<String> getCharacters()
	{
		List<String> list = characters['en'/*lang.getCode()*/] as List<String>;
		return list;
	}

	void selectChar(String char)
	{
		selected = char;
		_page = 0;
		getArtists();
		artistCards = [];
	}

	Map getMatchStage()
	{
		return {
			'\$match': { 'name': { '\$regex': '^$selected' } }
		};
	}

	void getArtists() async
	{
		// get count ============================
		dynamic countPipeline = js.jsify([
				getMatchStage(), { "\$count": "count" }
			]);

		_totalItems = await promiseToFuture(_artistColl.aggregate(countPipeline).first())
			.then((result) {
				int value = result != null ? js.getProperty(result, 'count') : 0;
				print('countPipeline $value');
				return value;
			});

		loadNextPage();
	}

	void loadNextPage() async
	{
		_page += 1;

		Map navigatorDetail = getNavigatorDetail(total: _totalItems, page: _page, perPage: _perPage);
		print('=== loadNextPage $navigatorDetail | page $_page');

		dynamic artistsPipeline = js.jsify([
			
			getMatchStage(),

			{
				'\$skip' : navigatorDetail['from']
			},

			{
				'\$limit': navigatorDetail['to']
			}
		]);

		dynamic artistDocs = await promiseToFuture(_artistColl.aggregate(artistsPipeline).asArray())
			.catchError(_handleError);

		artistDocs.forEach((doc) 
			{
				Map map = convertToMap(doc, SystemSchema.artist);
				Artist artist = Artist.fromjson(map);
				//print(artist.toDynamic());
				artistCards.add(artist.getAsWidget<Card>());
			});

		if(_page < navigatorDetail['pages']) 
			couldLoadMore = true;
		else couldLoadMore = false;
	}

	Exception _handleError(dynamic e) {
	    print(e); // for demo purposes only
	    return Exception('ArtistsExplorerComponent error; cause: $e');
	  }
}
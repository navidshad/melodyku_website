import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/core/injector.dart' as CI;
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/archive/archive.dart';

@Component(
	selector:'multi-categorizing',
	templateUrl: 'multi_categorizing_component.html',
	styleUrls: ['multi_categorizing_component.css'],
	directives: [
		SelectField,
    	DbCollectionTableEditorComponent,
	]
)
class MultiCategorizingComponent
{
	MongoDBService _mongodb;
	CategoryService _categoryService;
	PlayerService _playerService;

	CollectionOptions options;

	List<DbField> mediaTypes = SystemSchema.mediaItems;
	List<DbField> categories = [];
	List<DbField> docSchema = [];

	List<DbField> getmodes = [
    	DbField("hasn't", strvalue: "hasn't"),
    	DbField('has', strvalue: 'has'),
  	];

	String selectedMediaType = 'song';
	String selectedGetmod = "hasn't";
	String selectedCategory = '';

	MultiCategorizingComponent(this._mongodb, this._categoryService, this._playerService)
	{
		categories = _categoryService.getCategories();
		selectedCategory = categories[0].strvalue;

		reSetupTableOptions();
	}

	void onSelectorChanged(String selected, String type)
	{
		switch(type)
		{
			case 'mediaType': selectedMediaType = selected; break;
			case 'getmode'	: selectedGetmod = selected; break;
			case 'category'	: selectedCategory = selected; break;
		}

		reSetupTableOptions();
		options.clear();
	}

	Map<String, dynamic> getQuery() 
	{
		Map<String, dynamic> query = {};

	    if (selectedGetmod == "hasn't")
	      query = { 'categories': {'\$ne': selectedCategory} };

	    else if (selectedGetmod == "has")
	      query = { 'categories': {'\$eq': selectedCategory} };

	    return query;
	}

	List<ActionButton> getActionButtons() 
	{
		List<ActionButton> list = [];

		if (selectedGetmod == "hasn't")
		  list.add(ActionButton(title: 'add category', onEvent: addCategory));

		else if (selectedGetmod == "has")
		  list.add(ActionButton( title: 'remove category', onEvent: removeCategory));

		if(selectedMediaType == 'song')
			list.add(ActionButton( title: 'play', onEvent: playSong));

		return list;
	}

	void reSetupTableOptions()
	{
		// get schema
		if(selectedMediaType == 'artist') docSchema = SystemSchema.artist;
		else if(selectedMediaType == 'album') docSchema = SystemSchema.album;
		else if(selectedMediaType == 'song') docSchema = SystemSchema.song;

		SystemSchema.injectSubfields('categories', docSchema, 
			_categoryService.getGroups());

		// setup table
		if(options == null)
		{
			options = CollectionOptions(
		      database		: 'media',
		      allowAdd		: false,
		      allowUpdate	: true,
		      allowRemove	: false,
		      hasCover		: true,
		      autoGet		: false,
		    );
		}

		options.collection = selectedMediaType;
		options.dbFields = docSchema;
		options.query = getQuery();
		options.actionButtons = getActionButtons();
	}

	void addCategory(Map doc, ButtonOptions options)
	{
		options.doWaiting(true);

		Map query = { '_id': doc['_id'] };
		Map update = {'\$push': {'categories': selectedCategory}};

		_mongodb.updateOne(isLive:true, database: 'media', collection: selectedMediaType, 
			query: query, update: update)
		.then((r) 
	    {
	      options.doWaiting(false);
	      options.setActivation(false);
	    }).catchError((err) => options.doWaiting(false));
	}

	void removeCategory(Map doc, ButtonOptions options)
	{
		options.doWaiting(true);

		Map query = { '_id': doc['_id'] };
		Map update = {'\$pull': {'categories': selectedCategory}};

		_mongodb.updateOne(isLive:true, database: 'media', collection: selectedMediaType, 
			query: query, update: update)
		.then((r) 
	    {
	      options.doWaiting(false);
	      options.setActivation(false);
	    }).catchError((err) => options.doWaiting(false));
	}

	void playSong(Map doc, ButtonOptions options)
	{
		Song song = Song.fromjson(doc);
		_playerService.play(song);
	}
}
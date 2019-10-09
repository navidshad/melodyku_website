import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';

import 'media_item.dart';

class MediaPack<T extends MediaItem>
{
	String id;
	String title;
	String type;
	Map localTitle;
	List<String> categories;
	bool limitMode;
	int limitation;
	
	List<T> list;

	MediaPack({
		this.id, this.title, this.type, this.localTitle, this.categories, 
		this.limitMode, this.limitation, this.list
	});

	factory MediaPack.fromMap(Map detail)
	{
		MediaPack<T> pl;

		try{
			pl = MediaPack(
				id			: detail['_id'],
				title		: detail['title'],
				type		: detail['type'],
				localTitle	: detail['local_title'],
				categories	: detail['categories'],
				limitMode	: detail['limitMode'],
				limitation	: detail['limitation'],
			);

			if(detail.containsKey('list')) 
			{
				List<Map> mList = detail['list'];
				pl.list = [];

				mList.forEach((doc)
				{
					T item;
					
					if(T == Artist) item = Artist.fromjson(doc) as T;
					else if(T == Album) item = Album.fromPopulatedDoc(doc) as T;
					else if(T == Playlist) item = Playlist.fromjson(doc, listContainsObject:false) as T;

					pl.list.add(item);
				});

				pl.list = pl.list.reversed.toList();
			}

		}catch(e)
		{
			print('MediaPack.fromMap, $e');
			print(detail);
		}

		return pl;
	}

	List<Card> getChildsAsCardWidgets()
	{
		List<Card> cards = [];

		for(int i=0; i < list.length; i++)
		{
		  Card widget;

		  if(T == Artist)
		  {
		  	Artist mediaItem = list[i] as Artist;
		  	widget = mediaItem.getAsWidget<Card>();
		  }
		  else if(T == Album)
		  {
			Album mediaItem = list[i] as Album;
		  	widget = mediaItem.getAsWidget<Card>();
		  }
		  else if(T == Playlist)
		  {
		  	Playlist mediaItem = list[i] as Playlist;
		  	widget = mediaItem.getAsWidget<Card>();
		  }
		  
		  cards.add(widget);
		}

		return cards;
	}
}
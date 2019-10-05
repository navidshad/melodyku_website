import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';

class MediaPackEditor<T>
{
	String id;
	String title;
	String type;
	Map localTitle;
	List<String> categories;
	bool limitMode;
	int limitation;
	
	List<String> listIds;
	List<T> list;

	bool pending = false;
	MongoDBService _mongodb;

	MediaPackEditor({
		this.id, this.title, this.type, this.localTitle, this.categories, 
		this.limitMode, this.limitation, this.listIds, this.list
	})
	{
		_mongodb = Injector.get<MongoDBService>();
	}

	factory MediaPackEditor.fromMap(Map detail, { bool listContainesMediaObjects=false })
	{
		MediaPackEditor<T> pl;

		try{
			pl = MediaPackEditor(
				id			: detail['_id'],
				title		: detail['title'],
				type		: detail['type'],
				localTitle	: detail['local_title'],
				categories	: detail['categories'],
				limitMode	: detail['limitMode'],
				limitation	: detail['limitation'],
			);

			if(listContainesMediaObjects) 
			{
				List<Map> mList = detail['list'];
				pl.list = [];

				mList.forEach((doc)
				{
					T item;
					
					if(T == Artist) item = Artist.fromjson(doc) as T;
					else if(T == Album) item = Album.fromPopulatedDoc(doc) as T;
					else if(T == Playlist) item = Playlist.fromjson(doc) as T;

					pl.list.add(item);
				});

				pl.list = pl.list.reversed.toList();
			}
			else pl.listIds = detail['list'];

		}catch(e)
		{
			print('MediaPackEditor.fromMap, $e');
			print(detail);
		}

		return pl;
	}

	bool have(String mediaId) => listIds.contains(mediaId);

	void addOrRemoveById(String mediaId) async
	{
		if(pending) return;
		else pending = true;

		if(have(mediaId)) removeById(mediaId).whenComplete(() => pending = false);
		else addById(mediaId).whenComplete(() => pending = false);
	}

	Future<dynamic> addById(String mediaId) async
	{
		// remove first if the list is a limit one
		if(limitMode && limitation <= listIds.length)
		{
			String removingId = listIds[0];
			await removeById(removingId);
		}

		// add song to list
		Map query = { '_id': id };
		Map update = { '\$addToSet': { 'list': mediaId } };

		return _mongodb.updateOne(
			isLive: true, 
			database:'media', collection: 'media_pack', 
			query:query , update: update)

			.then((r) {
				if(listIds != null) listIds.add(mediaId);
			});
	}

	Future<dynamic> removeById(String mediaId)
	{
		Map query = { '_id': id };
		Map update = { '\$pull': { 'list': mediaId } };

		return _mongodb.updateOne(
			isLive: true, 
			database:'media', collection: 'media_pack', 
			query:query , update: update)

			.then((r) {
				if(listIds != null) listIds.remove(mediaId);
			});
	}
}
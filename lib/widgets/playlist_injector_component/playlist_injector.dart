import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class PlaylistInjector
{
	String id;
	String title;
	Map local_title;
	List<String> categories;
	List<String> list;
	bool limitMode;
	int limitation;

	bool pending = false;
	MongoDBService _mongodb;

	PlaylistInjector({
		this.id, this.title, this.local_title, this.categories, 
		this.list, this.limitMode, this.limitation
	})
	{
		_mongodb = Injector.get<MongoDBService>();
	}

	factory PlaylistInjector.fromMap(Map detail)
	{
		PlaylistInjector pl;

		try{

			pl = PlaylistInjector(
				id			: detail['_id'],
				title		: detail['title'],
				local_title	: detail['local_title'],
				categories	: detail['categories'],
				list		: detail['list'],
				limitMode	: detail['limitMode'],
				limitation	: detail['limitation'],
			);

		}catch(e)
		{
			print('PlaylistInjector.fromMap, $e');
		}

		return pl;
	}

	bool have(String songId) => list.contains(songId);

	void addOrRemove(String songId) async
	{
		if(pending) return;
		else pending = true;

		if(have(songId)) remove(songId).whenComplete(() => pending = false);
		else add(songId).whenComplete(() => pending = false);
	}

	Future<dynamic> add(String songId) async
	{
		// remove first if the list is a limit one
		if(limitMode && limitation <= list.length)
		{
			String removingId = list[0];
			await remove(removingId);
		}

		// add song to list
		Map query = { '_id': id };
		Map update = { '\$addToSet': { 'list': songId } };

		return _mongodb.updateOne(
			isLive: false, 
			database:'media', collection: 'playlist', 
			query:query , update: update)

			.then((r) => list.add(songId));
	}

	Future<dynamic> remove(String songId)
	{
		Map query = { '_id': id };
		Map update = { '\$pull': { 'list': songId } };

		return _mongodb.updateOne(
			isLive: false, 
			database:'media', collection: 'playlist', 
			query:query , update: update)

			.then((r) => list.remove(songId));
	}
}
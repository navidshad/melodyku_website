import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/services/services.dart';

class PlaylistEditor extends Playlist
{
	@override
	List<String> listIds;

	bool pending = false;
	MongoDBService _mongodb;

	PlaylistEditor({
		String id, String title, Map localTitle, List<String> categories, 
		List<Song> list, bool limitMode, int limitation, this.listIds=const[]
	}):super(
		id:id, title:title, localTitle:localTitle, 
		list:list, limitMode:limitMode, limitation:limitation
	)
	{
		_mongodb = Injector.get<MongoDBService>();
	}

	factory PlaylistEditor.fromMap(Map detail, { bool listContainesSongs=false })
	{
		PlaylistEditor pl;

		try{

			pl = PlaylistEditor(
				id			: detail['_id'],
				title		: detail['title'],
				localTitle	: detail['local_title'],
				categories	: detail['categories'],
				limitMode	: detail['limitMode'],
				limitation	: detail['limitation'],
			);

			if(listContainesSongs) 
			{
				List<Map> sList = detail['list'];
				pl.list = [];

				sList.forEach((doc){
					Song song = Song.fromPopulatedDoc(doc);
					pl.list.add(song);
				});

				pl.list = pl.list.reversed.toList();
			}
			else pl.listIds = detail['list'];

		}catch(e)
		{
			print('PlaylistEditor.fromMap, $e');
			print(detail);
		}

		return pl;
	}

	bool have(String songId) => listIds.contains(songId);

	void addOrRemoveById(String songId) async
	{
		if(pending) return;
		else pending = true;

		if(have(songId)) removeById(songId).whenComplete(() => pending = false);
		else addById(songId).whenComplete(() => pending = false);
	}

	Future<dynamic> addById(String songId) async
	{
		// remove first if the list is a limit one
		if(limitMode && limitation <= listIds.length)
		{
			String removingId = listIds[0];
			await removeById(removingId);
		}

		// add song to list
		Map query = { '_id': id };
		Map update = { '\$addToSet': { 'list': songId } };

		return _mongodb.updateOne(
			isLive: true, 
			database:'media', collection: 'playlist', 
			query:query , update: update)

			.then((r) {
				if(listIds != null && listIds.length > 0)
					listIds.add(songId);
			});
	}

	Future<dynamic> removeById(String songId)
	{
		Map query = { '_id': id };
		Map update = { '\$pull': { 'list': songId } };

		return _mongodb.updateOne(
			isLive: true, 
			database:'media', collection: 'playlist', 
			query:query , update: update)

			.then((r) {
				if(listIds != null && listIds.length > 0)
					listIds.remove(songId);
			});
	}
}
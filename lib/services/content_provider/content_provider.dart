/// {@nodoc}
library contentProvider;

import 'media_selector.dart';
import 'assets.dart';
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';

class ContentProvider 
{
	IndexedDBService _idb;
 	MediaSelector mediaselector;
 	UserService _userService;

	ContentProvider(this._idb, this._userService, MongoDBService mongoService)
	{
		mediaselector = MediaSelector(mongoService);
	}

	String getImage({String database='', String type='', String id='', String imgStamp='', randomPattern=true})
	{
		String link = '';

    // check local database
    // String id = 'img-$id';
    // Blob blob = await _idb.getOne('media', 'file', id);

		if(imgStamp.length > 0)
		{
			Uri imageLink = Uri.https(Vars.dataHost, 'images/$database-$type/$id-$imgStamp.jpg');
			link = imageLink.toString();
		}
		else if(randomPattern) link = getRandomPatterns();
		//print('$type, $imgStamp, $imgStamp_album, $imgStamp_artist \n$link');

		return link;
	}

	Future<String> getSongStreamLink(Song song, [String version]) async
	{
	// check local database
	String id = 'song-${song.id}';

	return _idb.getOne('media', 'file', id)
		.then((blob){
			if(blob != null) return Url.createObjectUrlFromBlob(blob);
			else throw('song dosent found on local db');
		})
		.catchError((e) => song.getStreamLink(version))
		.whenComplete(() => song.getStreamLink(version));
	}

	String getRandomPatterns()
	{
	  String pattern = Vars.host + '/' + patterns[randomRange(1, patterns.length)];
	  return pattern;
	}

	Future<dynamic> uploadImage({String database, String type, String id, FormElement form, Function onProgress})
	{
		String link = '${Vars.host}/image/upload';
		Completer completer = Completer();

		FormData formData = new FormData(form);
	    formData.append('database', database);
	    formData.append('type', type);
	    formData.append('id', id);

		final request = new HttpRequest();
	    request.open('POST', link);
	    request.setRequestHeader('orgine', window.location.origin);
	    request.setRequestHeader('authorization', _userService.token);

	    request.upload.onProgress
	    	.listen(onProgress);

    	request.onLoadEnd
    		.listen((e) 
    	{
    		String stamp = json.decode(request.response)['stamp'].toString();
    		print('image has been uploaded $stamp');
    		completer.complete(stamp);
    	});

	    request.onError
	    	.listen((error) {
    			print('image upload has error $error');
    			completer.completeError(error);
    		});

	    request.send(formData);

	    return completer.future;
	}

	Future<dynamic> removeImage({String database, String type, String id})
	{
		String link = '${window.location.origin}/image/remove';
		
		Map body = {'database': database, 'type': type, 'id':id};

		Map<String, String> header = {
			'orgine': window.location.origin,
			'authorization': _userService.token
		};
		
		Client http = Client();
		return http.post(link, body: body, headers: header);
	}

	Future<Map> downloadAsBuffer(String url, 
    {Function(int percent) onDownloading, String responseType= 'blob',}) async
	{
		return HttpRequest.request(
			Uri.parse(url).toString(),
			responseType: responseType,
			requestHeaders: {
				'orgin': window.location.origin,
				'Access-Control-allow-orgin': window.location.origin,
				},
			onProgress: (ProgressEvent pe) {
				onDownloading((pe.loaded*100/pe.total).toInt());
			})
			.then((resopnse)
			{
				return { 
					'contentType': resopnse.getResponseHeader('content-type'),
					'data': resopnse.response
				};
			});

		//return completer.future;
	}

	Future<void> downloadSong(Song song, Function(int percent) onDownloading) async
	{
	    // store song
		Map songDetail = song.getAsMap();
	    songDetail['storedDate'] = DateTime.now().microsecondsSinceEpoch;

	    // store artist and album
	    _idb.putOne('media', 'artist', song.artist.getAsMap());
	    _idb.putOne('media', 'album', song.album.getAsMap());

		// download song file
		String link = await song.getStreamLink('original');
		await downloadAsBuffer(link, onDownloading: onDownloading)
		// store song file
		.then((Map file)
		{
      		Blob blob = file['data'];
      		String id = 'song-' + songDetail['_id'];

			// add size
			songDetail['size_local'] = blob.size; //(doc['base64'].length / 1000);

			return _idb.insertOne('media', 'file', blob, id)
				.then((r) => print('song downloaded'));
		})

		// // download song thumbnail
		// .then((r)
		// {
		// 	String imglink = song.thumbnail;
		// 	String link = Uri.https(Vars.mainHost, 'stream/downloadfile', {'link': imglink}).toString();

		// 	print('begin to download img $link');

		// 	return downloadAsBuffer(link, onDownloading: (int percent) => print('thumbnail downloading $percent'));
		// })
		// // store thumbnail file
		// .then((Map file)
		// {
		// 	Map doc = {
		// 		'_id': 'img-' + songDetail['_id'],
		// 		'base64': DownloadFile.getBase64Link(file['contentType'], file['buffer'])
		// 	};

		// 	// add size
		// 	songDetail['size_local'] += (doc['base64'].length / 1000);

		// 	return _idb.insertOne('media', 'file', doc)
		// 		.then((r) => print('thumbnail downloaded'));
		// })
		// update song size
		.then((r) => _idb.insertOne('media', 'song', songDetail))
		// update quota info
		.then((r) => _idb.storageQuota.updateInfo())

		// remove song detail on error
		.catchError((err) 
		{
			_idb.removeOne('media', 'song', songDetail['_id']);
			_idb.removeOne('media', 'file', 'song-' + songDetail['_id']);
			_idb.removeOne('media', 'file', 'img-' + songDetail['_id']);

			print('song store process error $err');
			return throw(err);
		});
	}

	Future<dynamic> removeDownloadedSong(Song song) async
	{
		String id = song.id;
		String link = await song.getStreamLink('original');
		String CACHE_NAME = "user_downloads";

		// window.navigator.serviceWorker.getRegistration('/sw.js')
		// 	.then((sw)
		// 	{
		// 		Map<String,String> data = {
		// 			'action': 'REMOVE_CACHE',
		// 			'cacheName':CACHE_NAME, 
		// 			'url':link
		// 		};
		// 		sw.active.postMessage(data);
		// 	});

    // remove song detail
		return _idb.removeOne('media', 'song', id)
    // remove blob
    .then((r) => _idb.removeOne('media', 'file', 'song-$id'))
		// update quota info
		.then((r) => _idb.storageQuota.updateInfo());
	}
}
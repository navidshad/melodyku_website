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

class ContentProvider 
{
  	MediaSelector mediaselector;
  	UserService _userService;

	ContentProvider(this._userService, MongoDBService mongoService)
	{
		mediaselector = MediaSelector(mongoService);
	}

	String getImage({
		String database='', String type='', 
		String id, String imgStamp='', randomPattern=true})
	{
		String link = '';

		if(imgStamp.length > 0)
		{
			Uri imageLink = Uri.https(Vars.dataHost, 'images/$database-$type/$id-$imgStamp.jpg');
			link = imageLink.toString();
		}
		else if(randomPattern) link = getRandomPatterns();
		//print('$type, $imgStamp, $imgStamp_album, $imgStamp_artist \n$link');

		return link;
	}

	String getRandomPatterns()
	{
	  String pattern = patterns[randomRange(1, patterns.length)];
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
}
import 'stitch_archive.dart';
import 'archive.dart';
import 'package:http/http.dart';

import './requester.dart';
export './requester.dart';

import '../../services/stitch_service.dart';
import '../urls.dart';

class ContentProvider 
{
  	Archive archive;
  	StitchArchive stitchArchive;
	Requester requester;

	ContentProvider(this.requester, StitchService stitch)
	{
		stitchArchive = StitchArchive(stitch);
		archive = Archive(requester);

		//print('ContentProvider constructor, $stitchArchive');
	}

	Future<String> getImage({String type, String id, String imgStamp}) async
	{
		String link = '/';

		Uri imageLink = Uri.http(dataMelodyku, 'images/$type/$id-$imgStamp.jpg');
		
		link = imageLink.toString();

		// await requester.http.get(imageLink)
		// 	.then((Response response) 
		// 	{
		// 		print('getImage status code ${response.statusCode}');
		// 		if(response.statusCode == 200)
		// 			link = imageLink.toString();
		// 	})
		// 	.catchError((error) => print('getImage error $error'));
		
		return link;
	}
}
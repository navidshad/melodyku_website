import 'stitch_archive.dart';
import 'archive.dart';
import 'package:http/http.dart';

import './requester.dart';
export './requester.dart';

import './assets.dart';
import 'package:melodyku/src/class/utility/math.dart';
import '../../services/stitch_service.dart';
import '../urls.dart';

class ContentProvider 
{
  	Archive archive;
  	StitchArchive stitchArchive;
	Requester requester;

	ContentProvider(StitchService stitch)
	{
		stitchArchive = StitchArchive(stitch);
		//archive = Archive(requester);

		//print('ContentProvider constructor, $stitchArchive');
	}

	String getImage({String type, String id, String imgStamp})
	{
		String link;

		if(imgStamp.length > 0)
		{
			Uri imageLink = Uri.http(dataMelodyku, 'images/$type/$id-$imgStamp.jpg');
			link = imageLink.toString();
		}

		return link;
	}

	String getRandomPatterns()
	{
	  String pattern = patterns[randomRange(1, patterns.length)];
	  return pattern;
	}
}
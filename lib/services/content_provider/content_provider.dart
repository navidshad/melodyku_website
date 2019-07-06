/// {@nodoc}
library contentProvider;

import 'stitch_archive.dart';
import 'stitch_cloner_archive.dart';
import 'assets.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

class ContentProvider 
{
  StitchArchive stitchArchive;
  StitchClonerArchive stitchClonerArchive;


	ContentProvider(StitchService stitch, StitchClonerService stitchCloner)
	{
		stitchArchive = StitchArchive(stitch);
		stitchClonerArchive = StitchClonerArchive(stitchCloner);

		//print('ContentProvider constructor, $stitchArchive');
	}

	String getImage({
		String type='', String id, String imgStamp='',
		String imgStamp_album='', String imgStamp_artist='',
		String albumId='', String artistId=''})
	{
		String link;

		if(imgStamp.length > 10)
		{
			Uri imageLink = Uri.https(Vars.dataHost, 'images/$type/$id-$imgStamp.jpg');
			link = imageLink.toString();
		}
		else if(imgStamp_album.length > 10)
		{
			Uri imageLink = Uri.https(Vars.dataHost, 'images/album/$albumId-$imgStamp_album.jpg');
			link = imageLink.toString();
		}
		else if(imgStamp_artist.length > 10)
		{
			Uri imageLink = Uri.https(Vars.dataHost, 'images/artist/$artistId-$imgStamp_artist.jpg');
			link = imageLink.toString();
		}

		//print('$type, $imgStamp, $imgStamp_album, $imgStamp_artist \n$link');

		return link;
	}

	String getRandomPatterns()
	{
	  String pattern = patterns[randomRange(1, patterns.length)];
	  return pattern;
	}
}
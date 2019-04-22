import 'stitch_archive.dart';
import 'archive.dart';

import './requester.dart';
import '../../services/stitch_service.dart';

class ContentProvider 
{
  Archive archive;
  StitchArchive stitchArchive;

  ContentProvider(Requester rq, StitchService stitch)
  {
  	stitchArchive = StitchArchive(stitch);
    archive = Archive(rq);

    //print('ContentProvider constructor, $stitchArchive');
  }
}
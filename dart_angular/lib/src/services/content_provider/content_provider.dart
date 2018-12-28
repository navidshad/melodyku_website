import 'archive.dart';
import './requester.dart';

class ContentProvider 
{
  Archive archive;

  ContentProvider(Requester rq)
  {
    archive = Archive(rq);
  }
}
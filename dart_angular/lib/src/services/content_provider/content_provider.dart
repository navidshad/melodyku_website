import 'package:http/http.dart';
import 'archive.dart';

class ContentProvider 
{
  Client _http;
  Archive archive;

  ContentProvider(this._http)
  {
    archive = Archive(_http);
  }
}
import 'package:http/http.dart';
import 'archive.dart';
import '../user_service.dart';
import './requester.dart';

class ContentProvider 
{
  Client _http;
  Archive archive;
  UserService _userService;
  Requester _requester;

  ContentProvider(this._http, this._userService)
  {
    _requester = Requester(this._http, this._userService);
    archive = Archive(_requester);
  }
}
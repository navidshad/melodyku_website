import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'downloads_page.html',
  styleUrls: [ 'downloads_page.scss.css' ],
  )
class DownloadsPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  DownloadsPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(_userservice, _messageService, null, false, 'downloads');
  }
}
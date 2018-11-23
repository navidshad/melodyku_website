import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_artistList_page.html',
  styleUrls: [ 'archive_artistList_page.scss.css' ],
  )
class ArchiveArtistListPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  ArchiveArtistListPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(_userservice, _messageService, null, false, 'archive_artistList');
  }
}
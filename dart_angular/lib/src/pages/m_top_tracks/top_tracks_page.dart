import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'top_tracks_page.html',
  styleUrls: [ 'top_tracks_page.scss.css' ],
  )
class TopTracksPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  TopTracksPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(_userservice, _messageService, null, false, 'top_tracks');
  }
}
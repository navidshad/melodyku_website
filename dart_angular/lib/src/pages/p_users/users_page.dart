import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';

@Component(
  selector: 'page',
  templateUrl: 'users_page.html',
  styleUrls: [ 'users_page.scss.css' ],
  )
class UsersPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  UsersPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(_userservice, _messageService, null, false, 'users');
  }
}
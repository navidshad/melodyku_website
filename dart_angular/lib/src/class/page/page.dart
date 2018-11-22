import 'dart:html';
import '../user/permission.dart';
import '../../services/user_service.dart';

class Page
{
  UserService _userService;
  Permission _permission;
  bool _needLogedIn;
  String title;

  Page(this._userService, this._permission, this._needLogedIn, this.title);

  void checkAccess()
  {
    bool isEquale = _userService.user.permission.isEqualeTo(_permission);
    if(!isEquale) window.location.pathname = "";
  }
}
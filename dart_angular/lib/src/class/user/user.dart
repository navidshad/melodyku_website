import 'permission.dart';
import '../types.dart';

class User 
{
  Permission _permission;
  dynamic id;
  String fullname;
  String email;
  String country;
  String provience;
  String city;

  User(this.id, {bool fullAccess})
  {
    if(fullAccess != null && fullAccess)
    {
      _permission = Permission.fullaccess();
    }
  }

  bool hasAccess(PermissionType type) =>
    _permission?.hasAccess(type);
}
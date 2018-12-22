import 'permission.dart';

class User 
{
  Permission permission;
  dynamic id;
  String fullname;
  String email;
  String country;
  String provience;
  String city;

  User(this.id, this.fullname, this.email, {this.country, this.provience, this.city});

  factory User.fromJson(dynamic detail)
  {
    User user;
    try {
      print(detail);
      dynamic id = detail['_id'];
      String fullname = detail['fullname'];
      String email = detail['email'];
      user = User(id, fullname, email);
      user.permission = Permission.fromJson(detail['permission']);
      
    } catch (e) {
      throw e;
    }

    return user;
  }
}
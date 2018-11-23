import 'permission.dart';

class User 
{
  Permission permission;
  String fullname;
  String email;
  String country;
  String provience;
  String city;

  User(this.fullname, this.email, {this.country, this.provience, this.city});

  factory User.fromJson(dynamic detail)
  {
    User user;
    try {
      print(detail);
      String fullname = detail['fullname'];
      String email = detail['email'];
      user = User(fullname, email);
      user.permission = Permission.fromJson(detail['permission']);
      
    } catch (e) {
      throw e;
    }

    return user;
  }
}
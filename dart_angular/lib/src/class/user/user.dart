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
    try {

      String fullname = detail['fullname'];
      String email = detail['email'];
      return User(fullname, email);

    } catch (e) {
      throw e;
    }
  }
}
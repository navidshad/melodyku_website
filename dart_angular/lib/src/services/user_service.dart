import 'package:http/http.dart';
import '../class/user/user.dart';


export '../class/user/user.dart';

class UserService 
{
  Client _http;
  User user;
  bool isLogedIn = false;

  UserService(this._http);

  void login(String email, String password)
  {

  }

  void logout()
  {
    
  }

  void register(dynamic detail)
  {

  }
}
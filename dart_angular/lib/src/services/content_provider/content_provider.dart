import 'package:http/http.dart';
import 'archive.dart';
import '../user_service.dart';
import './requester.dart';

import '../../class/injector.dart';

class ContentProvider 
{
  Archive archive;

  static final _instance = ContentProvider();

  ContentProvider()
  {
    archive = Archive();
    
    // register this userService into Injectory.
    Injector.register(InjectorMember(this));
  }
  
  factory ContentProvider.getInstance() => _instance;
}
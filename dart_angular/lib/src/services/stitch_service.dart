import 'dart:async';
import 'dart:html';
import 'package:http/browser_client.dart';

import 'package:js/js_util.dart' as js;

import 'package:melodyku/mongo_stitch/app_client.dart';
export 'package:melodyku/mongo_stitch/app_client.dart';

class StitchService 
{
  BrowserClient _http;

  String app_id = 'melodyku-etevw';
  String _serviceName =  'mongodb-atlas';
  StitchAppClient appClient;
  RemoteMongoClient dbClient;

  StitchUser get user => appClient.auth.user;

  StitchService()
  {
    appClient = initializeDefaultAppClient(app_id);
    dbClient = appClient.getServiceClient(remoteMongoClientFactory, _serviceName);

    loginAnonymouse();
  }

  Future<void> loginAnonymouse()
  {
    if(appClient.auth.user != null) return null;

    Completer completer = Completer();

    //get user list
    //List users = appClient.auth.user listUsers(); //.forEach((u) => print('old user ' +  u.id));
    //print('users ${appClient.auth.user}');

    appClient.auth.loginWithCredential(AnonymousCredential()).then((newUser) 
    {
      print('user logined with Anonymouse');
      print(user.id);
      completer.complete();
    });

    return completer.future;
  }

  Future<dynamic> loginWithEmailPassword(String email, String password)
  {
    dynamic result = {'done':false, 'message':''};
    
    UserPasswordCredential credential = UserPasswordCredential(email, password);
    
    return promiseToFuture(appClient.auth.user.linkWithCredential(credential)).then((newUser)
    {
      print('user logined EmailPassword');
      print(user.id);
      
      result['done'] = true;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }

  Future<dynamic> loginWithAPIKey(String key)
  {
    dynamic result = {'done':false, 'message':''};

    UserApiKeyCredential credential = UserApiKeyCredential(key);

    return promiseToFuture(appClient.auth.loginWithCredential(credential)).then((newUser)
    {
      print('user logined EmailPassword');
      print(user.id);
      
      result['done'] = true;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }

  Future<dynamic> registerWithEmailPassword(String email, String password)
  {
    dynamic result = {'done':false, 'message':''};
    
    UserPasswordAuthProviderClient emailPassClient = appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    return promiseToFuture(emailPassClient.registerWithEmail(email, password))
    .then((u)
    {
      print('user registerd with EmailPassword');
      result['done'] = true;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }
}
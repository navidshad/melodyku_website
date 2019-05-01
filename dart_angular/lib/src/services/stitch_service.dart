import 'dart:async';
import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/mongo_stitch/app_client.dart';
export 'package:melodyku/mongo_stitch/mongo_stitch.dart';
export 'package:melodyku/src/class/archive/system_schema.dart';

class StitchService 
{
  String app_id = 'melodyku-etevw';
  String _serviceName =  'mongodb-atlas';
  StitchAppClient appClient;
  RemoteMongoClient dbClient;

  StitchUser get user => appClient.auth.user;

  StitchService()
  {
    print('StitchService constructor');
    appClient = initializeDefaultAppClient(app_id);
    dbClient = appClient.getServiceClient(remoteMongoClientFactory, _serviceName);

    loginAnonymouse();
  }

  // auth methods ===============================
  Future<void> loginAnonymouse()
  {
    if(appClient.auth.user != null) return null;

    Completer completer = Completer();

    //get user list
    //List users = appClient.auth.user listUsers(); //.forEach((u) => print('old user ' +  u.id));
    //print('users ${appClient.auth.user}');

    promiseToFuture(appClient.auth.loginWithCredential(AnonymousCredential())).then((newUser) 
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

  Future<dynamic> loginWithAPIKey(String key)
  {
    dynamic result = {'done':false, 'message':''};

    UserApiKeyCredential credential = UserApiKeyCredential(key);

    return promiseToFuture(appClient.auth.loginWithCredential(credential))
    .then((newUser)
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

  Future<dynamic> confirmEmail(String token, String tokenID)
  {
    dynamic result = {'done':false, 'message':''};

    UserPasswordAuthProviderClient emailPassClient = appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    return promiseToFuture(emailPassClient.confirmUser(token, tokenID))
    .then((msg)
    {
      print('email was confirmed');

      if(!msg.toString().contains('invalid token'))
        result['done'] = true;

      result['message'] = msg;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }

  Future<dynamic> resendConfirmationEmail(String email)
  {
    dynamic result = {'done':false, 'message':''};

    UserPasswordAuthProviderClient emailPassClient = appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    return promiseToFuture(emailPassClient.resendConfirmationEmail(email))
    .then((msg)
    {
      print('confirmation email was sent | $msg');
      result['done'] = true;
      result['message'] = msg;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }

  Future<dynamic> sendResetPasswordEmail(String email)
  {
    dynamic result = {'done':false, 'message':''};

    UserPasswordAuthProviderClient emailPassClient = appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    return promiseToFuture(emailPassClient.sendResetPasswordEmail(email))
    .then((msg)
    {
      print('reset link was sent | $msg');
      result['done'] = true;
      result['message'] = msg;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }

  Future<dynamic> resetPassword(String token, String tokenID, String newPassword)
  {
    dynamic result = {'done':false, 'message':''};

    UserPasswordAuthProviderClient emailPassClient = appClient.auth
      .getProviderClient(userPasswordAuthProviderClientFactory);
    
    return promiseToFuture(emailPassClient.resetPassword(token, tokenID, newPassword))
    .then((msg)
    {
      print('password was reseted');

      if(!msg.toString().contains('invalid token'))
        result['done'] = true;

      result['message'] = msg;
      return result;
    })
    .catchError((error){
      result['message'] = error.toString();
      return result;
    });
  }
}
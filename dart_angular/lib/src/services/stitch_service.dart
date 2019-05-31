import 'dart:async';
//import 'dart:html';
import 'package:js/js_util.dart' as js;

import 'package:melodyku/mongo_stitch/mongo_stitch.dart';

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
    log('log StitchService constructor');
    print('StitchService constructor');
    //appClient = initializeDefaultAppClientByHelper(app_id);
    appClient = initializeDefaultAppClient(app_id);
    dbClient = appClient.getServiceClient(remoteMongoClientFactory, _serviceName);

    loginAnonymouse();
  }

  // auth methods ===============================
  Future<void> loginAnonymouse()
  {
    if(appClient.auth.user != null) return null;
    //get user list
    //List users = appClient.auth.listUsers(); //.forEach((u) => print('old user ' +  u.id));
    print('users ${appClient.auth.user}');

    return promiseToFuture(loginAnonymouseByHelper(appClient))
      .then((newUser) 
      {
        print('user logined with Anonymouse');
        print(user.id);
      });
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
      log(error);
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
      log(error);
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
      log(error);
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
      log(error);
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
      log(msg);
      print('confirmation email was sent | $msg');
      result['done'] = true;
      result['message'] = msg;
      return result;
    })
    .catchError((error){
      log(error);
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
      log(error);
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
      log(error);
      result['message'] = error.toString();
      return result;
    });
  }

  // Queue Requester
  List<int> _queueNumbers = [];
  Future requestByQueue(Future request) async
  {
    // register a number for this rquest
    int stamp = DateTime.now().millisecondsSinceEpoch;
    _queueNumbers.add(stamp);

    print('request stamp registered $stamp');

    // waite untile the index of it's stamp get 0;
    await Future.doWhile(() async
    { 
        await Future.delayed(Duration(milliseconds: 100));
        
        if(_queueNumbers.indexOf(stamp) <= 0) return false;
        else return true;
    });

    // waite for performing request ans remove stamp
    return await request
      .whenComplete(() {
         _queueNumbers.remove(stamp);
         print('request of $stamp get done');
      });
  }
}
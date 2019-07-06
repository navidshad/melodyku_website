library user;

import 'permission.dart';
import 'subscription.dart';
import 'activity_tracker.dart';

import 'package:js/js_util.dart' as js;
import 'dart:html';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';

export 'activity_tracker.dart';
export 'permission.dart';
export 'subscription.dart';

class User 
{
  Permission _permission;
  ActivityTracker traker;

  Subscription _subscription;
  Subscription get subscription => _subscription;

  String id;
  dynamic detailId;
  String permissionId;
  String fullname;
  String email;
  String imgStamp;

  User(id, {
    this.detailId, 
    bool fullAccess= false, 
    bool getDetail=true,
    this.permissionId,
    this.fullname,
    this.email,
    this.imgStamp,
    })
  {
    this.id = id.toString();

    if(fullAccess) 
    {
      _permission = Permission.fullaccess();
      fullname = 'Administrator';
    }
    else if(getDetail) getData();

    _subscription = Subscription(id);
    traker = ActivityTracker(id);
  }

  // factory User.fromJson(Map detail)
  // {
  //   User p;

  //   print('user $detail');

  //   try{
  //     p = User(
  //       detail['refId'].toString(),
  //       detailId: detail['_id'],
  //       permissionId : detail['permissionId'],
  //       email : detail['email'],
  //       fullname : detail['fullname'],
  //       imgStamp : (detail['imgStamp']   != null) ? detail['imgStamp'] : '',
  //     );
  //   }
  //   catch(e){
  //     print('User.fromJson | $e');
  //   }

  //   return p;
  // }

  bool hasAccess(PermissionType type) 
  {
    bool access = false;
    if(_permission != null) access = _permission.hasAccess(type);
    return access;
  }

  bool get isLoadedData {
    if(_permission != null && subscription != null)
      return true;
    else return false;
  }

  void getData() async
  {
    StitchService stitch = Injector.get<StitchService>();
    RemoteMongoDatabase userDB = stitch.dbClient.db('user');

    //get detail
    dynamic detailQuery = js.jsify({'refId': id});

    Future userDetailRequest = promiseToFuture(userDB.collection('detail').find(detailQuery).first());
    
    await stitch.requestByQueue(userDetailRequest)
    .then((doc)
    {
      // reget data, this is for first login affter registeration.
      // because user data is created affter first login.
      if(doc == null) getData();

      Map converted = convertToMap(doc, SystemSchema.userDetail);
      //print('user detail | $converted');

      detailId = converted['_id'];
      fullname = converted.containsKey('fullname') ? converted['fullname'] : '';
      permissionId = converted['permissionId'];
      email = converted['email'];
      imgStamp = converted['imgStamp'];

    }).catchError(_catchError);


    // get permission 
    // Future permissionRequest = promiseToFuture(stitch.appClient.callFunction('getById', ['cms', 'permission', permissionId]));
    // await stitch.requestByQueue(permissionRequest)
    // .then((doc) 
    // {
    //   //print('user permission | $doc');
    //   dynamic pDetail = convertToMap(doc, SystemSchema.permission);
    //   _permission = Permission.fromJson(pDetail);
    // }).catchError(_catchError);

    StitchCatcherService stitchCatcher = Injector.get<StitchCatcherService>();
      stitchCatcher.getById(collection: 'permission', id: permissionId)
      .then((doc) 
      {
        //print('user permission | $doc');
        dynamic pDetail = convertToMap(js.jsify(doc), SystemSchema.permission);
        _permission = Permission.fromJson(pDetail);
      }).catchError(_catchError);
  }

  String getImage()
  {
    String link = '/assets/svg/icon_user.svg';

    if(imgStamp != null && imgStamp.length > 10)
      link = Injector.get<ContentProvider>().getImage(type: 'user', id: id, imgStamp: imgStamp);

    return link;
  }

  void updateSubscription() =>
    _subscription.getUserSubscription();

  void _catchError(error) => print(error);
}
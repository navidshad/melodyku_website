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

enum UserType {user, anonymous}

class User 
{
  Permission _permission;
  ActivityTracker traker;

  Subscription _subscription;
  Subscription get subscription => _subscription;

  UserType type;

  String id;
  dynamic detailId;
  String permissionId;
  String fullname;
  String email;
  String imgStamp;

  User(String id, {
    this.type,
    this.permissionId,
    bool getDetail=true,
    })
  {
    this.id = id;

    if(getDetail) getData();

    if(type == UserType.user)
    {
      _permission = Permission(permissionId);
      _subscription = Subscription(id);
      traker = ActivityTracker(id);
    }
  }

  static UserType getType(String type)
  {
    if(type == 'user') return UserType.user;
    else return UserType.anonymous;
  }

  bool hasAccess(PermissionType type) 
  {
    bool access = false;
    if(_permission != null) 
      access = _permission.hasAccess(type);

    return access;
  }

  bool get isLoadedData {
    if(_permission != null && subscription != null)
      return true;
    else return false;
  }

  void getData() async
  {
    MongoDBService mongodb = Injector.get<MongoDBService>();
    dynamic detailQuery = {'refId': id};
    
    await mongodb.findOne(database: 'user', collection: 'detail', query: detailQuery)
    .then((doc)
    {
      // reget data, this is for first login affter registeration.
      // because user data is created affter first login.
      if(doc == null) {
        getData();
        return;
      }

      Map converted = validateFields(doc, SystemSchema.userDetail);
      //print('user detail | $converted');

      detailId = converted['_id'];
      fullname = converted.containsKey('fullname') ? converted['fullname'] : '';
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

    // StitchCatcherService stitchCatcher = Injector.get<StitchCatcherService>();
    //   stitchCatcher.getById(collection: 'permission', id: permissionId)
    //   .then((doc) 
    //   {
    //     //print('user permission | $doc');
    //     dynamic pDetail = convertToMap(js.jsify(doc), SystemSchema.permission);
    //     _permission = Permission.fromJson(pDetail);
    //   }).catchError(_catchError);
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
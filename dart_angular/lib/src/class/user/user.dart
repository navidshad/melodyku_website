import 'permission.dart';
import '../types.dart';

import 'package:js/js_util.dart' as js;
import 'dart:html';

import 'package:melodyku/src/class/injector.dart' as CI;
import '../../services/stitch_service.dart';

class User 
{
  Permission _permission;
  dynamic id;
  String permissionName;
  String fullname;
  String email;

  User(this.id, { 
    bool fullAccess= false, 
    bool getDetail=true,
    this.permissionName,
    this.fullname,
    this.email
    })
  {
    if(fullAccess) {
      _permission = Permission.fullaccess();
      fullname = 'Administrator';
    }
    else if(getDetail) getData();
  }

  factory User.fromJson(dynamic detail)
  {
    User p;

    try{
      p = User(
      detail['rfId'],
      permissionName : detail['permissionName'],
      email : detail['email'],
      fullname : detail['fullname']);
    }
    catch(e){
      print('User.fromJson | $e');
    }

    return p;
  }

  bool hasAccess(PermissionType type) 
  {
    bool access = false;
    if(_permission != null) access = _permission.hasAccess(type);
    return access;
  }

  void getData() async
  {
    print('begin to get user detail');

    StitchService stitch = CI.Injector.get<StitchService>();
    RemoteMongoDatabase userDB = stitch.dbClient.db('user');

    //get detail
    dynamic detailQuery = js.jsify({'refId': id.toString()});

    await promiseToFuture(userDB.collection('detail').find(detailQuery).first())
    .then((doc)
    {
      //print('user detail | $doc');
      fullname = js.getProperty(doc, 'fullname');
      permissionName = js.getProperty(doc, 'permissionName');
      email = js.getProperty(doc, 'email');

    }).catchError(_catchError);


    // get permission
    dynamic permissQuery = js.jsify({'title': permissionName});

    await promiseToFuture(userDB.collection('permission').find(permissQuery).first())
    .then((doc) 
    {
      //print('user permission | $doc');
      dynamic pDetail = convertFromJS(doc);
      _permission = Permission.fromJson(pDetail);
    }).catchError(_catchError);
  }

  void _catchError(error) => print(error);
}
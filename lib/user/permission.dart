/// {@nodoc}
library permission;

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Permission 
{
  String id;
  bool customer_access = false;  
  bool anonymous_access = false;  
  bool archive_manager = false;
  bool categorizing = false;
  bool user_manager = false;
  bool quality_management = false;
  bool advanced_settings = false;

  Permission(this.id)
  {
    getPermission();
  }

  void getPermission()
  {
    AuthService _auth  = Injector.get<AuthService>();
    _auth.getPermission(id)
      .then((permission) 
      {
        customer_access   = permission['customer_access'];  
        anonymous_access  = permission['anonymous_access'];  
        archive_manager   = permission['archive_manager'];
        categorizing      = permission['categorizing'];
        user_manager      = permission['user_manager'];
        quality_management  = permission['quality_management'];
        advanced_settings   = permission['advanced_settings'];
      });
  }

  // compare two permission class
  bool isEqualeTo(Permission per)
  {
    bool isEquale = true;
    
    if(customer_access != per.customer_access)    isEquale = false;    
    if(archive_manager != per.archive_manager)    isEquale = false;
    if(categorizing != per.categorizing)          isEquale = false;
    if(user_manager != per.user_manager)          isEquale = false;
    if(quality_management != per.quality_management)  isEquale = false;
    if(advanced_settings != per.advanced_settings)    isEquale = false;

    return isEquale;
  }

  // check access of one permission Item
  bool hasAccess(PermissionType type)
  {
    bool has = false;

    switch (type) {
      case PermissionType.anonymous_access:
        has = anonymous_access;
        break;

      case PermissionType.customer_access:
        has = customer_access;
        break;

      case PermissionType.archive_manager:
        has = archive_manager;
        break;

      case PermissionType.categorizing:
        has = categorizing;
        break;

      case PermissionType.user_manager:
        has = user_manager;
        break;

      case PermissionType.quality_management:
        has = quality_management;
        break;

      case PermissionType.advanced_settings:
        has = advanced_settings;
        break;

      default: has = false;
    }

    return has;
  }
}
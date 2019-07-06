/// {@nodoc}
library permission;

import 'package:melodyku/core/types.dart';

class Permission {
  dynamic id;
  String title;
  bool isDefault;
  bool customer_access;  
  bool archive_manager;
  bool categorizing;
  bool user_manager;
  bool quality_management;
  bool advanced_settings;

  Permission({
    this.id,
    this.title,
    this.isDefault,
    this.customer_access,     
    this.archive_manager,
    this.categorizing,
    this.user_manager,
    this.quality_management,
    this.advanced_settings
    });

  factory Permission.fromJson(dynamic detail)
  {
    Permission p;
    try
    {
      p = Permission(
        id                : detail['_id'],
        title             : detail['title'],
        isDefault         : detail['isDefault'],
        advanced_settings : detail['advanced_settings'],
        categorizing      : detail['categorizing'],
        archive_manager   : detail['archive_manager'],
        customer_access   : detail['customer_access'],        
        quality_management: detail['quality_management'],
        user_manager      : detail['user_manager'],
      );

    } catch (e) {
      print('$e | $detail');
    }

    return p;
  }

  factory Permission.fullaccess()
  {
    return Permission(
        advanced_settings : true,
        isDefault         : false,
        categorizing      : true,
        archive_manager   : true,
        customer_access   : true,        
        quality_management: true,
        user_manager      : true,
      );
  }

  factory Permission.lessAccess()
  {
    return Permission(
        title: '',
        advanced_settings : false,
        isDefault         : false,
        categorizing      : false,
        archive_manager   : false,
        customer_access   : false,        
        quality_management: false,
        user_manager      : false,
      );
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
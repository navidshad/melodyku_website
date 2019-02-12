import '../types.dart';

class Permission {
  bool freemium_access = false;
  bool premium_access = false;
  bool archive_manager = false;
  bool categorizing = false;
  bool user_manager = false;
  bool quality_management = false;
  bool advanced_settings = false;

  Permission({
    this.freemium_access, 
    this.premium_access,
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
        advanced_settings : detail['advanced_settings'],
        categorizing      : detail['categorizing'],
        archive_manager   : detail['archive_manager'],
        freemium_access   : detail['freemium_access'],
        premium_access    : detail['premium_access'],
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
        categorizing      : true,
        archive_manager   : true,
        freemium_access   : true,
        premium_access    : true,
        quality_management: true,
        user_manager      : true,
      );
  }


  // compare two permission class
  bool isEqualeTo(Permission per)
  {
    bool isEquale = true;
    
    if(freemium_access != per.freemium_access)    isEquale = false;
    if(premium_access != per.premium_access)      isEquale = false;
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
      case PermissionType.freemium_access:
        has = freemium_access;
        break;

      case PermissionType.premium_access:
        has = premium_access;
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
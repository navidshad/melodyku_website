class Permission {
  bool freemium_access;
  bool premium_access;
  bool my_works;
  bool archive_manager;
  bool categorizing;
  bool user_manager;
  bool quality_management;
  bool advanced_settings;

  Permission();

  bool isEqualeTo(Permission per)
  {
    bool isEquale = true;
    
    if(freemium_access != per.freemium_access)    isEquale = false;
    if(premium_access != per.premium_access)      isEquale = false;
    if(my_works != per.my_works)                  isEquale = false;
    if(archive_manager != per.archive_manager)    isEquale = false;
    if(categorizing != per.categorizing)          isEquale = false;
    if(user_manager != per.user_manager)          isEquale = false;
    if(quality_management != per.quality_management)  isEquale = false;
    if(advanced_settings != per.advanced_settings)    isEquale = false;

    return isEquale;
  }
}
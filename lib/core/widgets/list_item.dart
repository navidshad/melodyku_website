/// {@nodoc}
library listItem;

import 'package:melodyku/core/types.dart';

class ListItem<T>
{
    String id;
    String title;
    String subtitle;
    
    String duration;
    String number;

    String titleLink;
    String thumbnail;

    Map localTitle;

    T origin;
    ArchiveTypes type;

    ListItem(this.title, 
    {
      this.id,
      this.subtitle, 
      this.duration, 
      this.number, 
      this.titleLink, 
      this.thumbnail, 
      this.origin,
      this.type,
      this.localTitle,
    });

  String getTitle(String languageCode)
  {
    String tempTitle = title;


    if(localTitle.containsKey(languageCode) && 
        localTitle[languageCode].length > 0)
      tempTitle = localTitle[languageCode];

    return tempTitle;
  }
}
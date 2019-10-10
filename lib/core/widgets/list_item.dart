/// {@nodoc}
library listItem;

import 'package:melodyku/core/types.dart';
import 'package:melodyku/archive/media_item.dart';

class ListItem<T extends MediaItem>
{
    String id;
    String title;
    String subtitle;
    
    String duration;
    String number;

    String titleLink;
    String thumbnail;

    Map localTitle;
    Map localTitle_sub;

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
      this.localTitle_sub,
    });

  String getTitle(String languageCode)
  {
    String tempTitle = title;


    if(localTitle != null && localTitle.containsKey(languageCode) && 
        localTitle[languageCode].length > 0)
      tempTitle = localTitle[languageCode];

    return tempTitle;
  }

  String getSubTitle(String languageCode)
  {
    String tempTitle = '';

    if(localTitle_sub != null && localTitle_sub.containsKey(languageCode) && 
        localTitle_sub[languageCode].length > 0)
      tempTitle = localTitle_sub[languageCode];

    if(tempTitle.length == 0) tempTitle = subtitle;

    return tempTitle;
  }
}
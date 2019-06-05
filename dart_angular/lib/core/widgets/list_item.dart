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
    });
}
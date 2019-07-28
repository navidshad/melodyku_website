/// {@nodoc}
library card;

import 'package:melodyku/core/types.dart';

class Card<T>
{
  String id;
  String title;
  String subtitle;
  
  String titleLink;
  String subtitleLink;
  String thumbnail;

  Map localTitle;

  T origin;
  ArchiveTypes type;

  Card(this.title, 
    { 
      this.id,
      this.subtitle, 
      this.subtitleLink,
      this.titleLink, 
      this.thumbnail , 
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
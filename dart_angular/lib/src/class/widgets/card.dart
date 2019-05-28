import '../classes.dart';
import '../../class/archive/media_item.dart';

class Card<T>
{
  String id;
  String title;
  String subtitle;
  
  String titleLink;
  String subtitleLink;
  String thumbnail;

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
    });
}
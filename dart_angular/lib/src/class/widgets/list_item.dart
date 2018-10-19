import '../classes.dart';

class ListItem extends Origin 
{
    String id;
    String title;
    String subtitle;
    
    String duration;
    String number;

    Uri titleLink;
    Uri thumbnail;

    ListItem(this.title, 
    {
      this.id,
      this.subtitle, 
      this.duration, 
      this.number, 
      this.titleLink, 
      this.thumbnail,
      ArchiveTypes type, 
      dynamic origin
    }) 
      : super(type, origin);
}
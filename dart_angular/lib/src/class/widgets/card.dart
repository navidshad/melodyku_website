import '../classes.dart';

class Card extends Origin 
{
  String id;
  String title;
  String subtitle;
  
  Uri titleLink;
  Uri thumbnail;

  Card(this.title, 
    { 
      this.id,
      this.subtitle, 
      this.titleLink, 
      this.thumbnail , 
      ArchiveTypes type, 
      dynamic origin
    }) 
      : super(type, origin);
}
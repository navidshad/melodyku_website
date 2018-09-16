class Card {
  String title;
  String subtitle;
  
  Uri titleLink;
  Uri thumbnail;

  Card(this.title, {this.subtitle, this.titleLink, this.thumbnail});
}
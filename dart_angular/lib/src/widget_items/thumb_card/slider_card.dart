class SliderCard {
  int width;
  int height;
  String title;
  String subtitle;
  
  Uri titleLink;
  Uri thumbnail;

  SliderCard(this.title, {this.width, this.height, this.subtitle, this.titleLink, this.thumbnail});
}
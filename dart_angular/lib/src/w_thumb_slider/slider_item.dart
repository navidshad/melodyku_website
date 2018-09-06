class SliderItem {
  int width;
  int height;
  String title;
  String subtitle;
  
  Uri titleLink;
  Uri thumbnail;

  SliderItem(this.title, {this.width, this.height, this.subtitle, this.titleLink, this.thumbnail});
}
class ThumbListItem {
    String title;
    String subtitle;
    int length;

    Uri titleLink;
    Uri thumbnail;

    ThumbListItem(this.title, {this.subtitle,  this.length, this.titleLink, this.thumbnail});
}
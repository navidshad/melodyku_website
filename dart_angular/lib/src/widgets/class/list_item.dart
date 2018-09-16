class ListItem {
    String title;
    String subtitle;
    
    int length;
    String number;

    Uri titleLink;
    Uri thumbnail;

    ListItem(this.title, {this.subtitle,  this.length, this.number, this.titleLink, this.thumbnail});

    String getDuration()
    {
      int hours = (length / 3600).floor();
      int minutes = (length % 3600 / 60).floor();
      int seconds =(length % 3600 % 60).floor();

      String duration ='';
      if(hours > 0) duration += '$hours:';
      duration += '$minutes:$seconds';

      return duration;
    }
}
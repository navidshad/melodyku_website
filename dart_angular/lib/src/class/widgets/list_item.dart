class ListItem {
    String title;
    String subtitle;
    
    int length;
    String number;

    Uri titleLink;
    Uri thumbnail;

    ListItem(this.title, {this.subtitle, this.length, 
      this.number, this.titleLink, this.thumbnail});

    String getDuration()
    {
      int tempLength = 0;
      if(length != null) tempLength = length;

      int hours   = (tempLength / 3600).floor();
      int minutes = (tempLength % 3600 / 60).floor();
      int seconds = (tempLength % 3600 % 60).floor();

      String duration ='';
      if(hours > 0) duration += '$hours:';
      duration += '$minutes:$seconds';

      return duration;
    }
}
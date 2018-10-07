import '../classes.dart';

class ArchiveToWidget 
{
  // singer -----------------------------------------------
  static List<Card> toCards(List list, ArchiveTypes type, [int total])
  {
    List<Card> tempList = [];

    // prepar total variable
    int totalItem = list.length;
    if(total != null && total <= totalItem) totalItem = total;

    for (var i = 0; i < totalItem; i++) 
    {
      // convert by archive type
      switch (type) {

        case ArchiveTypes.media:
          Media item = list[i] as Media;
          tempList.add(
            Card( item.title, 
                  subtitle: item.singer,
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.album:
          Album item = list[i] as Album;
          tempList.add(
            Card( item.name, 
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.singer:
          Singer item = list[i] as Singer;
          tempList.add(
            Card( item.name, 
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.playlist:
          Playlist item = list[i] as Playlist;
          tempList.add(
            Card( item.title, 
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;
      }
    }

    return tempList;
  }

  static List<ListItem> toItemList(List list, ArchiveTypes type, [int total])
  {
    List<ListItem> tempList = [];

    // prepar total variable
    int totalItem = list.length;
    if(total != null && total <= totalItem) totalItem = total;

    for (var i = 0; i < totalItem; i++) 
    {

      String itemNumber = getDigitStyle(i+1, 2);

      // convert by archive type
      switch (type) {

        case ArchiveTypes.media:
          Media item = list[i] as Media;
          tempList.add(
            ListItem( item.title, 
                  subtitle: item.singer,
                  number: itemNumber,
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.album:
          Album item = list[i] as Album;
          tempList.add(
            ListItem( item.name, 
                  number: itemNumber,
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.singer:
          Singer item = list[i] as Singer;
          tempList.add(
            ListItem( item.name, 
                  number: itemNumber,
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;

        case ArchiveTypes.playlist:
          Playlist item = list[i] as Playlist;
          tempList.add(
            ListItem( item.title,
                  number: itemNumber,
                  thumbnail: Uri(path: getRandomCovers(1)[0])
                  ));
          break;
      }
    }

    return tempList;
  }

}
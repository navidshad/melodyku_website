import '../classes.dart';

class ArchiveToWidget 
{
  // artist -----------------------------------------------
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
          Song item = list[i] as Song;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            Card( item.title, 
                  id: item.id,
                  subtitle: item.artist,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.media,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.album:
          Album item = list[i] as Album;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            Card( item.title, 
                  id: item.id,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.album,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.artist:
          Artist item = list[i] as Artist;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            Card( item.name, 
                  id: item.id,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.artist,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.playlist:
          Playlist item = list[i] as Playlist;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            Card( item.title, 
                  id: item.id,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.playlist,
                  origin: item.toDynamic()
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
          Song item = list[i] as Song;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            ListItem( item.title, 
                  id: item.id,
                  subtitle: item.artist,
                  duration: item.getDuration(),
                  number: itemNumber,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.media,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.album:
          Album item = list[i] as Album;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            ListItem( item.title, 
                  id: item.id,
                  number: itemNumber,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.album,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.artist:
          Artist item = list[i] as Artist;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            ListItem( item.name, 
                  id: item.id,
                  number: itemNumber,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.artist,
                  origin: item.toDynamic()
                  ));
          break;

        case ArchiveTypes.playlist:
          Playlist item = list[i] as Playlist;
          item.thumbnail = getRandomCovers(1)[0];
          tempList.add(
            ListItem( item.title,
                  id: item.id,
                  duration: item.getDuration(),
                  number: itemNumber,
                  thumbnail: Uri(path: item.thumbnail),
                  type: ArchiveTypes.playlist,
                  origin: item.toDynamic()
                  ));
          break;
      }
    }

    return tempList;
  }

  static ListItem toListItem(Song media)
  {
    media.thumbnail = getRandomCovers(1)[0];
    return ListItem( 
            media.title, 
            id: media.id,
            subtitle: media.artist,
            duration: media.getDuration(),
            thumbnail: Uri(path: media.thumbnail),
            type: ArchiveTypes.media,
            origin: media.toDynamic()
            );
  }
}
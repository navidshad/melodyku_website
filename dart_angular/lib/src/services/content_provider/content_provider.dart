import 'package:http/http.dart';
import 'dart:async';
import '../../class/classes.dart';
import 'archive.dart';

class ContentProvider 
{
  Client _http;
  Archive archive;

  ContentProvider(this._http)
  {
    archive = Archive(_http);
  }

  // Utility ----------------------------------------------
  Future<List<ListItem>> getPlaylistAsListItem(String playlistName, [int total]) async
  {
    // Playlist playlist = await archive.playlist_get(playlistName);
    // List<ListItem> tempList = [];

    // // prepar total variable
    // int totalItem = playlist.list.length;
    // if(total != null && total <= totalItem) totalItem = total;

    // for (var i = 0; i < totalItem; i++) 
    // {
    //   String itemNumber = getDigitStyle(i+1, 2);
    //   Media item = playlist.list[i];
    //   tempList.add(ListItem( item.title, 
    //               subtitle: item.singer,
    //               number: itemNumber,
    //               thumbnail: Uri(path: getRandomCovers(1)[0])
    //               ));
    // }

    // return tempList;
  }

  Future<List<Card>> getPlaylistAsCards(String playlistName, [int total]) async
  {
    // Playlist playlist = await archive.playlist_get(playlistName);
    // List<Card> tempList = [];

    // // prepar total variable
    // int totalItem = playlist.list.length;
    // if(total != null && total <= totalItem) totalItem = total;

    // for (var i = 0; i < totalItem; i++) 
    // {
    //   Media item = playlist.list[i];
    //   tempList.add(Card( item.title, 
    //               subtitle: item.singer,
    //               thumbnail: Uri(path: getRandomCovers(1)[0])
    //               ));
    // }

    // return tempList;
  }

}
import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'page',
  templateUrl: 'top_tracks_page.html',
  styleUrls: [ 'top_tracks_page.css' ],
  directives: [
    ListWideComponent,
    SliderRectComponent,
    GridComponent,
  ]
  )
class TopTracksPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  List<ListItem> top15Songs = [];
  List<Card> topOfAllTime = [];
  List<Card> lastSongs = [];

  // constructor ==================================
  TopTracksPage(this.lang, this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.customer_access,
      needLogedIn: false,
      title: 'top_tracks'
    );

    getContent();
  }

  void getContent() async 
  {

    // Result_Song rSong_top15 = await _contentProvider.archive
    //   .media_getAll(randomRange(0, 50), total: 15);

    // rSong_top15.list.forEach((song) {
    //   top15Songs.add(song.getAsWidget<ListItem>());
    // });

    // Result_Song rSong_allTime = await _contentProvider.archive
    //   .media_getAll(randomRange(0, 50), total: 10);

    // rSong_allTime.list.forEach((song) {
    //   topOfAllTime.add(song.getAsWidget<Card>());
    // });

    // Result_Song rSong_last = await _contentProvider.archive
    //   .media_getAll(randomRange(0, 50), total: 20);

    // rSong_last.list.forEach((song) {
    //   lastSongs.add(song.getAsWidget<Card>());
    // });      
  }
}
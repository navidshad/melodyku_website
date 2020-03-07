import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
    selector: 'playlistInjector',
    templateUrl: 'playlist_injector_component.html',
    styleUrls: [
      'playlist_injector_component.css'
    ],
    directives: [
      coreDirectives,
      formDirectives,
      DirectionDirective,
      ElementExtractorDirective,
    ])
class PlaylistInjectorComponent implements OnInit {
  PopupService popupService;
  UserService _userService;
  MongoDBService _mongodb;
  LanguageService lang;

  List<PlaylistEditor> playlists = [];
  
  SectionSwitcher switcher;
  Element base;

  @Input()
  String songid = '';

  @Input()
  bool isUserPlaylist = false;

  String get collection {
    return (isUserPlaylist) ? 'user_playlist' : 'playlist';
  }

  PlaylistInjectorComponent(this.popupService, this._userService, this._mongodb, this.lang);

  @override
  void ngOnInit() {
    getPlaylists();
  }

  void getElement(Element el) 
	{
		base = el;

		switcher = SectionSwitcher(
		[
		  el.querySelector('#playlistsView'),
		  el.querySelector('#addNewView'),
		], showFirst: 'playlistsView');
	}

  void getPlaylists() {
    Map query = {};
    List<DbField> dbFields = [];

    if (isUserPlaylist) {
      query['refId'] = _userService.user.id;
      dbFields = SystemSchema.user_playlist;
    }
    else {
      query['forGenerator'] = false;
      dbFields = SystemSchema.playlist;
    }

    _mongodb
        .find(
            isLive: true,
            database: 'media',
            collection: collection,
            query: query)
        .then((docs) {
      docs.forEach((doc) {
        Map validated = validateFields(doc, dbFields);
        PlaylistEditor pl =
            PlaylistEditor.fromMap(validated, isUserPlaylist: isUserPlaylist);
        if (pl != null) playlists.add(pl);
      });
    });
  }

  void createNewList(String title) async {
    print(title);
    switcher.hideAll();

    _mongodb.insertOne(
      database: 'media',
      collection: collection,
      doc: {
        'title': title, 
        'refId': _userService.user.id
        },
      isLive: true
    ).whenComplete(() {
      getPlaylists();
      switcher.show('playlistsView');
    });
  }
}

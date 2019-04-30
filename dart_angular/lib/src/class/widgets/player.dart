import 'dart:html';
import '../classes.dart';
import 'package:melodyku/src/services/content_provider/content_provider.dart';
import 'package:melodyku/src/services/user_service.dart';

class Player 
{
  // variables
  ContentProvider _contentProvider;
  UserService _userServide;
  
  List<Song> _list = [];
  List<ListItem> listItems = [];

  //List<>

  Song current;
  ImageButton playBtn;

  AudioElement _audio;
  AudioElement get audio => _audio;
  void set audio(AudioElement a){
    _audio = a;
    addListeners();
  }

  bool seeking = false;
  bool isShuffle = false;
  bool isLoop = false;

  double currentTime = 0.0;
  set(double timeValue) => currentTime = num.parse(timeValue.toString());
  double get getDuration => (!audio.duration.isNaN) ? audio.duration.toInt().toDouble() : 60.0;

  // constructor
  Player(this._contentProvider)
  {
    _userServide = Injector.get<UserService>();
    // create an audio element
    audio = AudioElement();
  }

  // events -------------------------------------
  addListeners()
  {
    // update slider
    _audio.onTimeUpdate.listen((e) {
      //print('seeking: $seeking');
      if(!seeking) currentTime = audio.currentTime.toInt().toDouble();
    });
    // stop when current was ended
    _audio.onEnded.listen((e) 
    {
      // tracke ended Song
      if(_userServide.isLogedIn)
        _userServide.user.traker.trackSong(current, action: TrackAction.play);

      if(isLoop) audio.play();
      else playBtn.clicked(false);
    });
  }
  void onSeekingSlider() => seeking = true;
  void onSeekingSliderDone() {
    seeking = false;
    audio.currentTime = currentTime;
  }
  void onSliderValueChange() {
    if(seeking) audio.currentTime = currentTime;
  }

  // play methods -------------------------------
  void play() 
  {
    if(audio.paused) {
      audio.play();
      playBtn.clicked(true);
    }
    else {
      audio.pause();
      playBtn.clicked(false);
    }
  }

  void playTrack(Song track) async
  {
    //add to Queue
    add(track);

    //puase player 
    audio.pause();
    playBtn.clicked(false);

    current = track;
    audio.currentTime = 0;

    // define version of Song
    String version = 'demo';
    if(_userServide.isLogedIn && _userServide.user.subscription.hasSubscription())
      version = '96';

    // get stream link
    String streamLink = await _contentProvider.archive.getStreamLink(id: track.id, version: version);
    print('streamLink $streamLink');
    audio.src = streamLink;

    play();
  }

  // playlisy method ----------------------------
  void remove(String id) {
    _list.removeWhere((item) => (item.id == id) ? true : false);
    listItems.removeWhere((item) => (item.id == id) ? true : false);
  }
  void repeat() => isLoop = !isLoop;
  void shuffle() => isShuffle = !isShuffle;
  
  void add(Song track) 
  {
    bool isAdded = false;

    _list.forEach((item) { 
      print('forEach | ${item}');
      if(track.id == item.id) 
        isAdded = true; 
    });

    if(!isAdded) {
      _list.add(track);
      listItems.add(track.getAsWidget<ListItem>());
    }
    print('added a media to list | ${track.id}');
  }

  void next() 
  {
    // shuffle
    if(isShuffle) {
      playShuffle();
      return;
    }

    // get current index
    int currentIndex;
    for (var i = 0; i < _list.length; i++) 
      if(current.id == _list[i].id) currentIndex = i;

    // play next
    if(currentIndex < _list.length)
    {
      Song newTrack = _list[currentIndex+1];
      playTrack(newTrack);
    }
  }

  void previous() 
  {
    // shuffle
    if(isShuffle) {
      playShuffle();
      return;
    }

    // get current index
    int currentIndex;
    for (var i = 0; i < _list.length; i++) 
      if(current.id == _list[i].id) currentIndex = i;

    // play previous
    if(currentIndex > 0)
    {
      Song newTrack = _list[currentIndex-1];
      playTrack(newTrack);
    }
  }

  void playShuffle()
  {
    Song newTrack = _list[randomRange(0, _list.length-1)];
    playTrack(newTrack);
    //_list = _list.map((f) => f);
  }
}
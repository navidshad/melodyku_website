/// {@nodoc}
library player;

import 'dart:html';
import 'dart:async';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/core/core.dart';

class Player 
{
  // variables
  UserService _userServide;
  AnalyticService _analytic;
  
  List<Song> _list = [];
  List<ListItem> listItems = [];

  //List<>

  Song current;
  String version;
  ImageButton playBtn;

  AudioElement _audio;
  AudioElement get audio => _audio;
  void set audio(AudioElement a){
    _audio = a;
    addListeners();
  }

  bool isPlaying = false;
  bool hasSong = false;
  bool seeking = false;
  bool isShuffle = false;
  bool isLoop = false;

  double currentTime = 0.0;
  set(double timeValue) => currentTime = num.parse(timeValue.toString());
  double get getDuration => (!audio.duration.isNaN) ? audio.duration.toInt().toDouble() : 1;

  // constructor
  Player()
  {
    _userServide = Injector.get<UserService>();
    _analytic = Injector.get<AnalyticService>();

    // create an audio element
    audio = AudioElement();
  }

  // events -------------------------------------
  void addListeners()
  {
    // update slider
    _audio.onTimeUpdate.listen((e) {
      isPlaying = true;
      //print('seeking: $seeking');
      if(!seeking) currentTime = audio.currentTime.toInt().toDouble();
    });

    // stop when current was ended
    _audio.onEnded.listen((e) 
    {
      isPlaying = false;
      // tracke played Song
      if(_userServide.isLogedIn)
        _userServide.user.traker.reportPlayedSong(current);

      if(isLoop) audio.play();
      else {
        playBtn.clicked(false);
        // next track
        next();
      }
    });

    _audio.onPause.listen((e) {
      isPlaying = false;
    });
  }
  void onSeekingSlider() => seeking = true;
  void onSeekingSliderDone() {
    seeking = false;
    audio.currentTime = currentTime;
  }
  void onSliderValueChange() {
    if(seeking) audio.currentTime = currentTime;
    //print('onSliderValueChange');
  }

  // play methods -------------------------------
  void play() 
  {
    if(audio.paused) 
    {
      audio.play();
      playBtn.clicked(true);

      // track playling
      String lable = '${current.artist}-${current.title}';
      _analytic.trackEvent('play', category: 'player', label: lable, value: current.id);
    }
    else {
      audio.pause();
      playBtn.clicked(false);
    }
  }

  void playByTrack(Song track) async
  {
    //add to Queue
    add(track);

    //puase player 
    audio.pause();
    playBtn.clicked(false);

    current = track;
    audio.currentTime = 0;

    hasSong = false;
    await Future.delayed(Duration(milliseconds: 200));

    String source;

    // define version of Song
    version = 'demo';
    if(_userServide.isLogedIn && _userServide.user.subscription.hasSubscription())
      version = 'original';

    // get stream link
    source = await current.getStreamLink(version);

    //print('streamLink $streamLink , duration ${current.duration}');
    audio.src = source;

    play();
    hasSong = true;
  }

  void playByList(List<Song> list)
  {
    _list = list;
    listItems = list.map((song) => song.getAsWidget<ListItem>()).toList();
    playByTrack(list[0]);
  }

  // playlisy method ----------------------------
  void remove(String id) {
    _list.removeWhere((item) => (item.id == id) ? true : false);
    listItems.removeWhere((item) => (item.id == id) ? true : false);
  }
  void repeat() {
    _analytic.trackEvent('repeat play', category: 'player');
    isLoop = !isLoop;
  }

  void shuffle() {
    _analytic.trackEvent('play shuffle', category: 'player');
    isShuffle = !isShuffle;
  }
  
  void add(Song track) 
  {
    bool isAdded = false;

    _list.forEach((item) { 
      if(track.id == item.id) 
        isAdded = true; 
    });

    if(!isAdded) {
      _list.add(track);
      listItems.add(track.getAsWidget<ListItem>());
    }
    //print('added a media to list | ${track.id}');
  }

  void next() 
  {
    _analytic.trackEvent('play next song', category: 'player');

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
    if(currentIndex < _list.length-1)
    {
      Song newTrack = _list[currentIndex+1];
      playByTrack(newTrack);
    }
    else current = null;
  }

  void previous() 
  {
    _analytic.trackEvent('play previous song', category: 'player');

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
      playByTrack(newTrack);
    }
  }

  void playShuffle()
  {
    Song newTrack = _list[randomRange(0, _list.length-1)];
    playByTrack(newTrack);
  }
}
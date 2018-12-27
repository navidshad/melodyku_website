import 'dart:html';
import '../classes.dart';
import '../../services/content_provider/content_provider.dart';

class Player 
{
  // variables
  ContentProvider _contentProvider;
  List<ListItem> list = [];
  Media current;
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
  Player(this._contentProvider){
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

  void playTrack(Media track) async
  {
    //add to Queue
    add(track);

    //puase player 
    audio.pause();
    playBtn.clicked(false);

    current = track;
    audio.currentTime = 0;

    // get stream link
    String streamLink = await _contentProvider.archive.getStreamLink(track.id);
    audio.src = streamLink;

    play();
  }

  // playlisy method ----------------------------
  void remove(String id) => list.removeWhere((item) => (item.id == id) ? true : false);
  void repeat() => isLoop = !isLoop;
  void shuffle() => isShuffle = !isShuffle;
  
  void add(Media track) 
  {
    bool isAdded = false;
    list.forEach((item) { if(track.id == item.id) isAdded = true; });
    if(!isAdded) list.add(ArchiveToWidget.toListItem(track));
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
    for (var i = 0; i < list.length; i++) 
      if(current.id == list[i].id) currentIndex = i;

    // play next
    if(currentIndex < list.length)
    {
      Media newTrack = list[currentIndex+1].origin;//Media.fromjson(list[currentIndex+1].origin);
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
    for (var i = 0; i < list.length; i++) 
      if(current.id == list[i].id) currentIndex = i;

    // play previous
    if(currentIndex > 0)
    {
      Media newTrack = Media.fromjson(list[currentIndex-1].origin);
      playTrack(newTrack);
    }
  }

  void playShuffle()
  {
    Media newTrack = Media.fromjson( list[randomRange(0, list.length)].origin );
    playTrack(newTrack);
    list = list.map((f) => f);
  }
}
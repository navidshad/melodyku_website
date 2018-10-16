import 'dart:html';
import '../classes.dart';
import '../../services/content_provider/content_provider.dart';

class Player 
{
  // variables
  ContentProvider _contentProvider;
  Media current;
  List<Media> list = [];
  bool seeking = false;
  ImageButton playBtn;

  AudioElement _audio;
  AudioElement get audio => _audio ;
  void set audio(AudioElement a){
    _audio = a;
    addListeners();
  }

  double currentTime = 0.0;
  set(double timeValue) => currentTime = num.parse(timeValue.toString());
  double get getDuration => (!audio.duration.isNaN) ? audio.duration.toInt().toDouble() : 60.0;

  // constructor
  Player(this._contentProvider){
    audio = AudioElement();
  }

  // events
    addListeners()
  {
    // update slider
    _audio.onTimeUpdate.listen((e) {
      if(!seeking) currentTime = audio.currentTime.toInt().toDouble();
    });
    // syop when current was ended
    _audio.onEnded.listen((e) {
      playBtn.clicked(false);
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

  // play methods
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

  void playTrack(Media track)
  {
    current = track;
    audio.currentTime = 0;
    audio.src = '/assets/track.mp3';
    play();
  }


  void next() => {};
  void previous() => {};
  void repeat() => {};
  void shuffle() => {};
  void loop() => audio.loop = !audio.loop;
}
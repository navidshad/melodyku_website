import 'dart:html';
import '../classes.dart';
import '../../services/content_provider/content_provider.dart';

class Player 
{
  ContentProvider _contentProvider;
  Media current;
  bool seeking = false;

  AudioElement _audio;
  AudioElement get audio => _audio ;
  void set audio(AudioElement a)
  {
    _audio = a;
    _audio.onTimeUpdate.listen((e) {
      if(!seeking) currentTime = audio.currentTime.toInt().toDouble();
    });
  }

  Player(this._contentProvider)
  {
    audio = AudioElement();
  }

  void setCurrent(Media media)
  {
    current = media;

    audio.currentTime = 0;
    audio.src = '/assets/track.mp3';
    audio.play();
  }

  double currentTime = 0.0;
  set(double timeValue) => currentTime = num.parse(timeValue.toString());
  double get getDuration => (!audio.duration.isNaN) ? audio.duration.toInt().toDouble() : 60.0;

  // events
  void onSeekingSlider() => seeking = true;
  void onSeekingSliderDone() {
    seeking = false;
    audio.currentTime = currentTime;
  }
  void onSliderValueChange() {
    if(seeking) audio.currentTime = currentTime;
  }
}
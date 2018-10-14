import 'dart:html';
import '../classes.dart';
import '../../services/content_provider/content_provider.dart';

class Player 
{
  ContentProvider _contentProvider;
  Media current;

  AudioElement _audio;
  AudioElement get audio => _audio ;
  void set audio(AudioElement a)
  {
    _audio = a;
    _audio.onTimeUpdate.listen((e) 
    {
      print('onTimeUpdate');
      currentTime = audio.currentTime.toInt().toDouble();
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

  String get getDurationStr
  {
    String duration = '0:00';
    num audioDuration = (audio != null) ? audio.duration : 0.0;
    if(current != null) duration = current.getDuration(audioDuration);
    return duration;
  }

  String get getCurrentTimeStr
  {
    String getCurrentTime = '0:00';
    num audioCurrentTime = (audio != null) ? audio.currentTime : 0.0;
    if(current != null) getCurrentTime = current.getDuration(audio.currentTime);
    return getCurrentTime;
  }

  double get getDuration => (!audio.duration.isNaN) ? audio.duration.toInt().toDouble() : 60.0;
  
  double currentTime = 0.0;
  set(double timeValue) => 
    audio.currentTime = num.parse(timeValue.toString());
}
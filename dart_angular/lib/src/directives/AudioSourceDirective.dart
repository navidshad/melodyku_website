import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';

@Directive(
  selector: '[audioSource]'
)
class AudioSourceDirective {
  Element elementRef;
  AudioElement audio ;
  final _onAudio = StreamController<AudioElement>();

  AudioSourceDirective(Element elementRef)
  {
    this.elementRef = elementRef;
    audio = elementRef as AudioElement;
    _onAudio.add(audio);
    print('audio tag was catched');
  }

  @HostListener('emptied')
  void onEmptied()
  {
    print('audio source is empty');
  }

  @Output()
  Stream<AudioElement> get audioElement => _onAudio.stream;
}
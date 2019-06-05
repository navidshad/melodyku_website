/// {@nodoc}
library ElementExtractorDirective;

import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:async';

@Directive(
  selector: '[extractor]'
)
class ElementExtractorDirective
{
  final extractor = StreamController<Element>();

  ElementExtractorDirective(Element element) {
    extractor.add(element);
  }

  @Output('onExtract')
  Stream get extractElement => extractor.stream;
}
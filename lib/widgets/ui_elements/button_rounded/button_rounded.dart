import 'package:angular/angular.dart';
import 'dart:html';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
  selector: 'rounded-button',
  templateUrl: 'button_rounded.html',
  styleUrls: ['button_rounded.css'],
  directives: [coreDirectives, ElementExtractorDirective],
)

class ButtonRounded implements OnChanges {

  @Input()
  ButtonOptions options;

  @Input()
  dynamic arg;

  String colorClass = '';

  bool isWaiting = false;
  bool isActive = true;
  HtmlElement btnElement;

  void ngOnChanges(Map<String, SimpleChange> changes) {

    if (options != null) {
      options.waitingController.stream.listen(doWaiting);
      options.colorController.stream.listen(setColor);
      options.statusController.stream.listen(setStatus);
    }

  }

  void onClick() {
    if (isWaiting || !isActive) return;

    options.arg = arg;

    options.done();

  }

  void setStatus(bool key) => isActive = key;
  void onEaxtractElement(HtmlElement el) {}//=> btnElement = el;
  
  void doWaiting(bool key) {
    isWaiting = key;
  }

  void setColor(String color) => colorClass = 'btn-$color';//btnElement.classes.add();
}


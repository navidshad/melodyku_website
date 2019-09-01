@JS()
library gtag;

import 'package:js/js.dart';

@JS('gtag')
external void send(String type, String eventName, dynamic options);

@JS('gtag')
external void setOptions(String type, dynamic options);
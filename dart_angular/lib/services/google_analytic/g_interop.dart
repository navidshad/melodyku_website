@JS()
library gtag;

import 'package:js/js.dart';

@JS('gtag')
external void send(String type, String eventName, dynamic options);
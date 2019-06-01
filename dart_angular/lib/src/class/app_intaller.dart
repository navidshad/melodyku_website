@JS()
library install;

import 'package:js/js.dart';

@JS('isInstalled')
external bool get isInstalled;

@JS()
external bool getInstallStatus();

@JS()
external void installPWA();

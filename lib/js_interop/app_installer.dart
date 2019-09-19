/// {@nodoc}
@JS()
library install;

import 'package:js/js.dart';
import 'dart:html';

@JS('isInstalled')
external bool get isInstalled;

@JS()
external bool getInstallSupportStatus();

@JS('installPWA')
external dynamic _installPWA();
Future<bool> installPWA() => promiseToFuture(_installPWA());

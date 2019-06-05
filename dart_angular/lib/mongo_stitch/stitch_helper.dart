/// {@nodoc}
@JS()
library stitch_helper;

import 'package:js/js.dart';
import 'app_client.dart';

@JS('initializeDefaultAppClient')
external StitchAppClient initializeDefaultAppClientByHelper(String app_id);

@JS('loginAnonymouse')
external dynamic loginAnonymouseByHelper(dynamic appClient);

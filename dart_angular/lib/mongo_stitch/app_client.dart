@JS('stitch')
library stitch;

import 'package:js/js.dart';

import 'modules/module.dart';
import './interfaces/interface.dart';
import 'class/stitch_interop.dart';

export 'modules/module.dart';
export './class/class.dart';
export './interfaces/interface.dart';

export 'functions.dart';

@JS('stitch.Stitch.StitchAppClient')
class StitchAppClient {
  external RemoteMongoClient getServiceClient(dynamic remoteMongoClientFactory, String app_service_name);
  external PromiseJsImpl callFunction(String name, List<dynamic> args);
  
  @JS()
  StitchAuth auth;
}

@JS('RemoteMongoClient.factory')
external dynamic get remoteMongoClientFactory;

@JS('UserPasswordAuthProviderClient.factory')
external dynamic get userPasswordAuthProviderClientFactory;

@JS('Stitch.initializeDefaultAppClient')
external StitchAppClient initializeDefaultAppClient(String app_id);


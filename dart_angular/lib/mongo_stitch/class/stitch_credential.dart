@JS('stitch')
library stitch;

import 'package:js/js.dart';

@JS()
abstract class StitchCredential 
{
  external dynamic get material;

  @JS()
  dynamic providerCapabilities;

  external String get providerName;
  external String get providerType;  
}

@JS()
class AnonymousCredential implements StitchCredential
{
  external dynamic get material;

  @JS()
  dynamic providerCapabilities;

  external String get providerName;
  external String get providerType;
}

@JS()
class CustomCredential implements StitchCredential
{
  external factory CustomCredential(String token);

  external dynamic get material;

  @JS()
  dynamic providerCapabilities;

  external String get providerName;
  external String get providerType;
}

@JS()
class UserPasswordCredential implements StitchCredential
{
  external factory UserPasswordCredential(String email, String password);
  external dynamic get material;

  @JS()
  dynamic providerCapabilities;

  external String get providerName;
  external String get providerType;

  external String get username;
  external String get password;
}

@JS()
class UserApiKeyCredential implements StitchCredential
{
  external factory UserApiKeyCredential(String key);
  
  external dynamic get material;

  @JS()
  dynamic providerCapabilities;

  external String get providerName;
  external String get providerType;  
}
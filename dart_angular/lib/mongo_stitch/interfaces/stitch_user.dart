import 'package:js/js.dart';

import '../class/stitch_credential.dart';
import '../class/stitch_interop.dart';

@JS()
abstract class StitchUserIdentity {
  external String get id;
  external String get providerType;
}

@JS()
abstract class StitchUserProfile {
  external String get birthday;
  external String get email;
  external String get firstName;
  external String get gender;
  external String get lastName;
  external String get maxAge;
  external String get minAge;
  external String get name;
  external String get pictureUrl;
}

@JS()
class StitchUser{
  external String get id;
  external List<StitchUserIdentity> get identities;
  external String get loggedInProviderName;
  external String get loggedInProviderType;
  external StitchUserProfile get profile;
  external String get userType;

  // methods
  // linkUserWithRedirect
  // linkWithCredential

  external PromiseJsImpl<StitchUser> linkWithCredential(StitchCredential credential);
}
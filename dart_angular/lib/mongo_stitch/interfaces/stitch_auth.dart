import 'package:js/js.dart';

import '../class/stitch_credential.dart';
import '../class/stitch_interop.dart';
import '../modules/UserPasswordAuthProviderClient.dart';
import './stitch_user.dart';


@JS()
abstract class StitchAuth {
  external bool get isLoggedIn;
  external StitchUser get user;

  external PromiseJsImpl<StitchUser> loginWithCredential(StitchCredential credential);
  external UserPasswordAuthProviderClient getProviderClient(dynamic authProviderClientFactory, [String providerName]);
  external PromiseJsImpl logout();
  external List<StitchUser> listUsers();
}
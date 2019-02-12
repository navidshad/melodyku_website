import 'package:js/js.dart';
import '../class/stitch_interop.dart';

@JS()
class UserPasswordAuthProviderClient 
{
	external dynamic get factory;

	external PromiseJsImpl<dynamic> confirmUser(String token, String tokenId);
	external PromiseJsImpl<void> registerWithEmail(String email, String password);
	external PromiseJsImpl<dynamic> resendConfirmationEmail(String email);
	external PromiseJsImpl<dynamic> resetPassword(String token, String tokenId, String password);
	external PromiseJsImpl<dynamic> sendResetPasswordEmail(String email); 
}
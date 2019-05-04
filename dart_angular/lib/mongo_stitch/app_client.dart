@JS('stitch')
library stitch;

import 'package:js/js.dart';
import 'js_interop.dart';

@JS('Stitch.StitchAppClient')
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

// ==============================================
// classes
// ==============================================
@JS()
abstract class RemoteMongoReadOperation {
  external PromiseJsImpl<List<dynamic>> asArray();
  external PromiseJsImpl<dynamic> first();
  external PromiseJsImpl<RemoteMongoCursor> iterator();
  external PromiseJsImpl<List<dynamic>> toArray();
}

@JS()
abstract class RemoteMongoCursor {
  external void next();
}

// stitch_credential
//
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

// ==============================================
// interfaces
// ==============================================
// remoteMongoCollection
// 
@JS()
abstract class RemoteMongoCollection {
  external String get namespace;

  external RemoteMongoReadOperation               aggregate(dynamic pipeline);
  external PromiseJsImpl<int>                     count([dynamic query, dynamic options]);
  external PromiseJsImpl<RemoteDeleteResult>      deleteMany(dynamic query);
  external PromiseJsImpl<RemoteDeleteResult>      deleteOne(dynamic query);
  external RemoteMongoReadOperation               find([dynamic query, dynamic options]);
  external PromiseJsImpl<RemoteInsertManyResult>  insertMany(dynamic documents);
  external PromiseJsImpl<RemoteInsertOneResult>   insertOne(dynamic documents);
  external PromiseJsImpl<RemoteUpdateResult>      updateMany(dynamic query, dynamic update, [dynamic updateOptions]);
  external PromiseJsImpl<RemoteUpdateResult>      updateOne(dynamic query, dynamic update, [dynamic updateOptions]);
}

@JS()
abstract class RemoteDeleteResult {
  external int get deletedCount;
}

@JS()
abstract class RemoteInsertManyResult {
  external dynamic get insertedIds;
}

@JS()
abstract class RemoteInsertOneResult {
  external dynamic get insertedId;
}

@JS()
abstract class RemoteUpdateResult {
  external int get matchedCount;
  external int get modifiedCount;
  external dynamic get upsertedId;
}

@JS()
class RemoteCountOptions {
  external factory RemoteCountOptions(int limit);
}

@JS()
class RemoteFindOptions {
  external factory RemoteFindOptions(int limit, dynamic projection, dynamic sort);
}

@JS()
class RemoteUpdateOptions {
  external factory RemoteUpdateOptions([bool upsert]);
}

// RemoteMongoDatabase
// 
@JS()
abstract class RemoteMongoDatabase {
  external String get name;
  external RemoteMongoCollection collection(String name);
}

// StitchAuth
// 
@JS()
abstract class StitchAuth {
  external bool get isLoggedIn;
  external StitchUser get user;

  external PromiseJsImpl<StitchUser> loginWithCredential(StitchCredential credential);
  external UserPasswordAuthProviderClient getProviderClient(dynamic authProviderClientFactory, [String providerName]);
  external PromiseJsImpl logout();
  external List<StitchUser> listUsers();
}

// stitch user
// 
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

// ==============================================
// modules
// ==============================================
@JS()
class RemoteMongoClient
{
  external static dynamic get factory;
  external RemoteMongoDatabase db(String name);
}

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
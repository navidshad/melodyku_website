@JS()
library purechat_adapter;

import 'package:js/js.dart';
import 'dart:html';

@JS('getPureChatApi')
external dynamic _getPureChatApi();
Future<PureChatAPI> getPureChatApi() {
  return promiseToFuture(_getPureChatApi())
    .then((api) => PureChatAPI(api));
}

@JS()
class _PureChatAPI
{
  external void set(dynamic parameter, dynamic value);
  external dynamic get(dynamic param01);
}

class PureChatAPI
{
  _PureChatAPI _api;

  PureChatAPI(this._api);

  void set(dynamic parameter, dynamic value) => _api.set(parameter, value);
  dynamic get(dynamic param01) => _api.get(param01);

  void openChat() => _api.set('chatbox.expanded', true);
  void closeChat() => _api.set('chatbox.expanded', false);
}


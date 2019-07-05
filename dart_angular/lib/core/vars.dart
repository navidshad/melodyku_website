/// {@nodoc}
library vars;

import 'dart:html';

class Vars 
{
  static String mainHost = 'melodyku.com';
  static String dataHost = 'data.melodyku.com';

  static String get stitchClonerUrl
  {
  	String host = window.location.host.contains('localhost') ? Vars.mainHost : window.location.host;
  	return Uri.https(host, 'stitchCloner').toString();
  }

  static String get stitchCatcherUrl
  {
    String host = window.location.host.contains('localhost') ? Vars.mainHost : window.location.host;
    return Uri.https(host, 'stitchCatcher').toString();
  }

  static String get host
  {
  	String host = window.location.host.contains('localhost') ? Vars.mainHost : window.location.host;
  	return host;
  }
}
/// {@nodoc}
library vars;

import 'dart:html';

class Vars 
{
  static String mainHost = 'melodyku.com';
  static String dataHost = 'data.${Vars.mainHost}';

  static String get host
  {
  	String host = window.location.host.contains('localhost') ? Vars.mainHost : Vars.mainHost;//window.location.host;
  	return Uri.https(host, '').toString();
  }
}
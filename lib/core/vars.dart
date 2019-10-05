/// {@nodoc}
library vars;

import 'dart:html';

class Vars 
{
  static String mainHost = 'melodyku.ir';
  static String dataHost = 'data.${Vars.mainHost}';

  static String get host
  {
  	String host = 
  		(
  			window.location.host.contains('localhost') || 
  			window.location.host.contains('192')
  		) 
  		? Vars.mainHost 
  		: window.location.host;

  	return Uri.https(host, '').toString();
  }
}
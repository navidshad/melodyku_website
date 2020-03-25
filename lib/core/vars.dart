/// {@nodoc}
library vars;

import 'dart:html';

class Vars 
{
  // host
  static String mainHost = 'melodyko.ir';
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

  // player
  static int trakcSongWhenThisPercentPassed = 50;
}
import 'package:intl/intl.dart';

DateTime getDate(DateTime dt)
{
  	// create Date as String
    DateFormat formatter = new DateFormat('yyyy-MM-dd');
    String strDate = formatter.format(dt);

	// parse string date as From 
	return DateTime.parse(strDate);
}

DateTime getDateFromString(String str)
{
  DateTime dt = DateTime.parse(str);
  return getDate(dt);
}
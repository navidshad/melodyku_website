/// {@nodoc}
library language;

import '../types.dart';

class Language
{
  String name;
  String code;
  String flag;
  Direction direction;
  Map strings;

  Language({this.code, this.name, this.flag, this.direction, this.strings});

  // ask a string
  String getStr(String str)
  {
    String string  = '';

    try {
      string = strings[str];
    } catch (e) {
      print('the $name dosent found');
    }

    if(string == null || string.length == 0) string  = str;

    return string;
  }

  dynamic getDetail()
  {
    dynamic detail = { 'name': name, 'flag': flag };
    return detail;
  }
}

String getLocalValue(Map localObj, String languageCode)
{
  String tempTitle = '';

  if(localObj.containsKey(languageCode) && 
      localObj[languageCode].length > 0)
    tempTitle = localObj[languageCode];

  return tempTitle;
}
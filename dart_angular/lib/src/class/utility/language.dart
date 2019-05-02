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
    String string  = '$name-$str';

    try {
      string = strings[str];
    } catch (e) {
      print('the $name dosent found');
    }

    return string;
  }

  dynamic getDetail()
  {
    dynamic detail = { 'name': name, 'flag': flag };
    return detail;
  }
}
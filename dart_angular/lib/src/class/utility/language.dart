import '../types.dart';

class Language
{
  String name;
  String flag;
  Direction direction;
  dynamic _strings;

  Language(this.name, this.flag, this.direction, this._strings);

  // ask a string
  String getStr(String str)
  {
    String string  = '$name-$str';

    try {
      string = _strings[str];
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
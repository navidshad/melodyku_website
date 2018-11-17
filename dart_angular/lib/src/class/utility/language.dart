import '../types.dart';

class Language
{
  String name;
  String flag;
  Direction direction;
  dynamic _strings;

  Language(this.name, this.flag, this.direction, this._strings);

  // ask a string
  String getStr(String name)
  {
    String string  = "";

    try {
      string = _strings[name];
    } catch (e) {
      print('the $name dosent found');
    }

    return string;
  }
}
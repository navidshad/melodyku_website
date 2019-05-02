import '../class/utility/language.dart';
import './language/language_strings.dart';

class LanguageService 
{
  int _current;
  List<Language> _languageList;

  LanguageService() {
    _languageList = List<Language>();
    prepareLanguages();
  }

  // base methods ===============================
  List<dynamic> get languageList
  {
    List langs = List();
    _languageList.forEach((Language lang) 
      => langs.add(lang.getDetail()));
    return langs;
  }

  int get current => _current;

  void switchTo(int index) => 
    _current = index;

  String getStr(String name) => 
    _languageList[_current].getStr(name);

  String getDirection() => 
    _languageList[_current].direction.toString();

  String getFlag() => 
    _languageList[_current].flag;

  String getName() =>
    _languageList[_current].name;

  String getCode() =>
    _languageList[_current].code;

  // prepration =================================
  void prepareLanguages()
  {
    // loop per language
    for (var i = 0; i < language_detail_List.length; i++) 
    {
      // get lang detail
      dynamic ld = language_detail_List[i];

      // get lang strings
      dynamic strings = extractStringsByCode(ld['code']);

      // create lang
      Language language = Language(
          code: ld['code'],
          name: ld['name'], 
          flag: ld['flag'], 
          direction: ld['direction'], 
          strings: strings
        );

      _languageList.add(language);

      // get current
      if(ld['default'] != null && ld['default']) 
        _current = _languageList.length-1;
    }
  }

  dynamic extractStringsByCode(String code)
  {
    dynamic extracted = {};
    
    for (var i = 0; i < languageStrings.length; i++) 
    {
      // get string detail
      dynamic langString = languageStrings[i];
      String name = langString['name'];

      // extract
      extracted[name] = langString[code];
    }

    // return
    return extracted;
  }
}
import '../class/utility/language.dart';
import './language/language_strings.dart';

class LanguageService 
{
  int _current;
  List<Language> languageList;

  LanguageService() {
    prepareLanguages();
  }

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
      Language language = Language(ld['name'], ld['flag'], ld['direction'], strings);
      languageList.add(language);

      // get current
      if(ld['default']) _current = languageList.length-1;
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
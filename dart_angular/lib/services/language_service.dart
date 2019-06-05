/// {@nodoc}
library languageService;

import 'dart:html';
import 'package:melodyku/core/utility/language.dart';
import 'package:melodyku/core/system_schema.dart';
import 'language/language_strings.dart';
import 'stitch_service.dart';

class LanguageService 
{
  int _current;
  List<Language> _languageList;
  List<Map> languageDocs = [];
  StitchService _stitch;

  LanguageService(this._stitch) 
  {
    _languageList = List<Language>();
    prepareLanguages();
    getLanguages();
  }

  // base methods ===============================
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

  void getLanguages() async
  {
    promiseToFuture(_stitch.dbClient.db('media').collection('language').find().asArray())
      .then((list) 
      {
          print('prepareOptions got languages ${list.length}');
          list.forEach((jsDoc) 
          {
              Map doc = convertToMap(jsDoc, SystemSchema.language);
              languageDocs.add(doc);
          });
      });
  }

  List<DbField> getLanguageFiels()
  {
    List<DbField> list = [];

    languageDocs.forEach((mapDoc) =>
        list.add( DbField(mapDoc['code']) ));

    return list;
  }

  List<dynamic> getLanguageMaps()
  {
    List<Map> langs = [];
    _languageList.forEach((Language lang) 
      => langs.add(lang.getDetail()));
    return langs;
  }
}
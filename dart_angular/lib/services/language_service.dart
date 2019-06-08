/// {@nodoc}
library languageService;

import 'dart:html';
import 'package:js/js_util.dart' as js;
import 'package:melodyku/core/core.dart';
import 'language/language_strings.dart';
import 'stitch_service.dart';

class LanguageService 
{
  int _current;
  List<Language> _languageList;
  List<Map> languageDocs = [];
  StitchService _stitch;

  bool loaded = false;

  LanguageService(this._stitch) 
  {
    _languageList = [];
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

  List<String> getCodes()
  {
    List<String> codes = [];
    _languageList.forEach((language) => codes.add(language.code));
    return codes;
  }

  // prepration =================================
  void prepareLanguages()
  {
    for (var i = 0; i < languageDocs.length; i++) 
    {
      // get lang detail
      dynamic ld = languageDocs[i];

      if(!ld['isActive']) continue;

      // get lang strings
      dynamic strings = extractStringsByCode(ld['code']);

      // create lang
      Language language = Language(
          code: ld['code'],
          name: ld['title'], 
          flag: ld['flag'], 
          direction: (ld['direction'] == 'rtl') ? Direction.rtl : Direction.ltr, 
          strings: strings
        );

      _languageList.add(language);

      // get current
      if(ld['isDefault']) 
        _current = _languageList.length-1;
    }

    loaded = true;
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
    //dynamic query = js.jsify({'isActive': true});
    await promiseToFuture(_stitch.dbClient.db('cms').collection('language_config').find().asArray())
      .then((list) 
      {
          //print('prepareOptions got languages ${list.length}');
          list.forEach((jsDoc) 
          {
              Map doc = convertToMap(jsDoc, SystemSchema.language);
              languageDocs.add(doc);
          });
      });

    prepareLanguages();
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
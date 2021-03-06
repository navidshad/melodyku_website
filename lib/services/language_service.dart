/// {@nodoc}
library languageService;

import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class LanguageService 
{
  int _current;
  List<Language> _languageList;
  List<Map> languageDocs = [];
  //StitchService _stitch;
  MongoDBService _mongodb;

  bool loaded = false;

  LanguageService(this._mongodb) 
  {
    _languageList = [];
    
    // will be called from app shell
    //getLanguages();
  }

  // base methods ===============================
  int get current => _current;

  void switchTo(int index) {
    _current = index;
    _saveSession();
  }

  String getStr(String name, [Map replacment]) 
  {
    String strTemp = name;

    if(_current != null) 
      strTemp = _languageList[_current].getStr(name);

    if(replacment != null)
      replacment.forEach((key, value) 
        => strTemp = strTemp.replaceAll(key, value.toString()));
    
    return strTemp;
  }

  Direction getDirection() 
  {
    if(loaded)
      return _languageList[_current].direction;
    else return Direction.ltr;
  }

  String getDir() =>
    getDirection().toString().replaceAll('Direction.', '');

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
  void _saveSession() =>
    window.localStorage['current_language'] = current.toString();

  void _loadSession()
  {
    try{
      _current = int.parse(window.localStorage['current_language']);
    }catch(e){}
  }

  void _prepareLanguages(List<dynamic> strs)
  {
    for (var i = 0; i < languageDocs.length; i++) 
    {
      // get lang detail
      dynamic ld = languageDocs[i];

      if(!ld['isActive']) continue;

      // get lang strings
      dynamic strings = _extractStringsByCode(ld['code'], strs);

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

  dynamic _extractStringsByCode(String code, List<dynamic> strings)
  {
    dynamic extracted = {};
    
    for (var i = 0; i < strings.length; i++) 
    {
      // get string detail
      dynamic langString = strings[i];
      String title = langString['title'];

      // extract
      try{
        extracted[title] = langString['local_str'][code];
      }catch(e)
      {
        extracted[title] = null;
      }
    }

    // return
    return extracted;
  }

  Future<void> _getLanguageStr() async
  {
    return _mongodb.find(database: 'cms', collection: 'languageStr');
  }

  Future<void> getLanguages() async
  {
    await _mongodb.find(database: 'cms', collection: 'language_config')
    .then((list) 
    {
        list.forEach((doc) 
        {
            Map converted = validateFields(doc, SystemSchema.language);
            languageDocs.add(converted);
        });
    })
    .then((r) => _getLanguageStr())
    .then((strs) 
    {
      _prepareLanguages(strs as List<dynamic>);
      _loadSession();
    });
  }

  List<DbField> getLanguageFiels()
  {
    List<DbField> list = [];

    languageDocs.forEach((mapDoc) =>
        list.add( DbField(mapDoc['code'], fieldType: FieldType.textbox, isLowerCase: true) ));

    return list;
  }

  List<dynamic> getLanguageMaps()
  {
    List<Map> langs = [];
    _languageList.forEach((Language lang) 
      => langs.add(lang.getDetail()));
    return langs;
  }

  String getLocalValue(Map localTitle)
  {
    String code = getCode();
    String tempTitle = '';

    if( localTitle != null &&
        localTitle.containsKey(code) && 
        localTitle[code].length > 0)

    tempTitle = localTitle[code];
    return tempTitle;
  }
}
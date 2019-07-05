/// {@nodoc}
library languageService;

import 'package:js/js_util.dart' as js;
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/language/language_strings.dart';
import 'package:melodyku/services/services.dart';

class LanguageService 
{
  int _current;
  List<Language> _languageList;
  List<Map> languageDocs = [];
  //StitchService _stitch;
  StitchCatcherService _stitchCatcher;

  bool loaded = false;

  LanguageService(this._stitchCatcher) 
  {
    _languageList = [];
    getLanguages();
  }

  // base methods ===============================
  int get current => _current;

  void switchTo(int index) => 
    _current = index;

  String getStr(String name) {
    if(_current != null)
      return _languageList[_current].getStr(name);
    else return name;
  }

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
    // Future request = promiseToFuture(_stitch.dbClient.db('cms').collection('language_config').find().asArray());

    // await _stitch.requestByQueue(request)
    //   .then((list) 
    //   {
    //       //print('prepareOptions got languages ${list.length}');
    //       list.forEach((jsDoc) 
    //       {
    //           Map doc = convertToMap(jsDoc, SystemSchema.language);
    //           languageDocs.add(doc);
    //       });
    //   });

    await _stitchCatcher.getAll(collection: 'language_config')
        .then((list) 
        {
            print('prepareOptions got languages ${list.length}');
            list.forEach((doc) 
            {
                Map converted = convertToMap(js.jsify(doc), SystemSchema.language);
                languageDocs.add(converted);
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